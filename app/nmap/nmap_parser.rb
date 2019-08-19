class NmapParser
  require 'nmap/program'
  require 'nmap/xml'

  attr_reader :result

  def initialize(path)
    @cpe_helper = EnvizonCpe.new
    @xml = path
    @result = []
  end

  def parse
    Nmap::XML.new(@xml) do |xml|
      @result = [xml.scanner.arguments, xml.scanner.start_time]

      xml.up_hosts.each do |host|
        client = prepare_client(host)
        os_info(host, client)
        os_type(host, client)
        scripts(host, client) if host.host_script && host.host_script.scripts
        ports(host, client)
        groups(client) if client.groups.blank? || client.groups.where(name: 'Unknown').present?

        client.save
      end
    end
  end

  def prepare_client(host)
    client = Client.where(ip: host.ip).first_or_create
    client.hostname = host.hostname
    client.ip = host.ip unless client.ip?
    client.mac = host.mac unless client.mac?
    client.vendor = host.vendor unless client.vendor?
    client
  end

  def os_info(host, client)
    begin
      accuracy = 0
      os = ''
      host.os && host.os.each do |os_match|
        next unless os_match.accuracy > accuracy
        os = os_match.name
        accuracy = os_match.accuracy
      end
      client.os = os unless os.blank? || client.os.present?
      client.save
    rescue => exception
      puts "Faild to get os_info ->"
      puts "host => #{host}"
      puts "client => #{client}"
      puts "exception => #{e}"
    end
      
  end

  def os_type(host, client)
    cpe = ''
    type = ''
    accuracy = 0
    host.os && host.os.classes.each do |os_class|
      next unless os_class.accuracy > accuracy
      cpe = os_class.cpe.first
      type = os_class.type
      accuracy = os_class.accuracy
    end
    client.cpe = cpe unless cpe.blank?
    client.ostype = type unless type.blank?
    client.save
  end

  def scripts(host, client)
    host.host_script.script_data.each_pair do |name, data|
      data.default = '' if data.is_a?(Hash)
      db_output = Output.where(client_id: client.id, name: name).first_or_create
      db_output.client = client
      db_output.name = name
      # TODO: modify storage/display of data
      db_output.value = YAML.dump(data)
      db_output.save

      case name
      when 'nbstat'
        nbstat(client, data) if !data.empty?
      when 'smb-os-discovery'
        smb_os(client, data) if !data.empty?
      when 'smb-security-mode'
        set_label(client, 'SMB Signing') if data['message_signing'].casecmp('disabled').zero? if !data.empty?
      when 'smb-vuln-ms17-010'
        set_label(client, 'MS17-010') if data['CVE-2017-0143']['state'].casecmp('vulnerable').zero? if !data.empty?
      when 'smb-vuln-ms08-067'
        set_label(client, 'MS08-067') if data['CVE-2008-4250']['state'].casecmp('vulnerable').zero? if !data.empty?
      end
    end
  end

  def ports(host, client)
    host.ports.each do |port|
      next unless port.state == :open
      db_port = Port.where(client_id: client.id, number: port.number).first_or_create
      db_port.client_id = client.id
      db_port.number = port.number
      if port.service
        db_port.service = "#{port.service.ssl? ? 'ssl/' : ''}#{port.service.name}" unless db_port.sv
        if port.service.product.present?
          db_port.description = port.service.product
          db_port.description += ' ' + port.service.version if port.service.version.present?
          db_port.sv = true
        end
      end
      port_scripts(db_port, port) if port.scripts
      db_port.save
    end
  end

  def port_scripts(db_port, port)
    port.script_data.each_pair do |name, data|
      data.default = '' if data.is_a?(Hash)
      output = Output.where(port_id: db_port.id, name: name).first_or_create
      output.port_id = db_port.id
      output.name = name
      output.value = YAML.dump(data)
      output.save

      case name
      when 'http-ntlm-info'
        hostname = data['DNS_Computer_Name']
        hostname = data['NetBIOS_Computer_Name'] if hostname.blank?
        client.hostname = hostname unless hostname.blank?
      when 'ftp-anon'
        set_label(client, 'Anonymous FTP') if data.include? 'Anonymous FTP login allowed'
      end
    end
  end

  def groups(client)
    unknown = Group.where(name: 'Unknown').first_or_create(mod: false, icon: '<i class="fa fa-desktop"></i>')
    group_name = @cpe_helper.group(client)
    group = Group.where(name: group_name).first_or_create(mod: false, icon: @cpe_helper.icon(client))
    group.clients << client unless group.clients.find_by(id: client.id).present?
    if client.groups.count > 1
      unknown.clients.delete client if unknown.clients.find_by(id: client.id).present?
    end
    group.save
  end

  def set_label(client, labeltext)
    client.labels << Label.find_by_name(labeltext) unless client.labels.find_by_name(labeltext).present?
    client.save
  end

  def nbstat(client, data)
    hostname = data['server-name']
    mac = data['mac']['address'] if data['mac'['address]']] =~ /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/
    vendor = data['mac']['vendor']

    client.hostname = hostname
    client.mac = mac
    client.vendor = vendor
  end

  def smb_os(client, data)
    set_label(client, 'Null Session') if data['os'].present?
    hostname = data['fqdn']
    hostname = data['server'].gsub('\\x00', '') if hostname.blank?
    client.hostname = hostname unless hostname.blank?

    cpe = data['cpe']
    client.cpe = cpe unless cpe.blank?
    os = data['lanmanager'] if cpe.downcase.include?('microsoft')
    client.os = os unless os.blank?
  end
end
