class NmapParser
  require 'nmap/command'
  require 'nmap/xml'

  attr_reader :result

  def initialize(path)
    @cpe_helper = EnvizonCpe.new
    @xml = path
    @result = []
  end

  # main method to work through nmap xml
  def parse
    Nmap::XML.open(@xml) do |xml|
      @result = [xml.scanner.arguments, xml.scanner.start_time]
      xml.up_hosts.each do |host|
        db_client = prepare_client(host)
        os_info(host, db_client)
        os_type(host, db_client)
        host&.host_script&.scripts&.each_value do |script|
          parse_script(script, db_client)
        end
        ports(host, db_client)
        groups(db_client) if db_client.groups.blank? || db_client.groups.where(name: 'Unknown').present?

        db_client.save
      end
    end
  end

  # find or intiate the host in database and return it. setup the main host parameters from the nmap xml
  def prepare_client(host)
    client = Client.where(ip: host.ip).first_or_create
    client.hostname = host.hostname if client.hostname.blank?
    client.ip = host.ip unless client.ip?
    client.mac = host.mac unless client.mac?
    client.vendor = host.vendor unless client.vendor?
    client
  end

  # search for the operating system with the highest probability using the nmap xml. 
  # if an OS is already known for the host, it is not overwritten in this method. 
  # the results are only approximate, but are often the best you can get. 
  # Exact operating system (and their version) which are extracted from scripts, stay unchanged by this method.
  def os_info(host, client)
    unless client.os.present?
      begin
        accuracy = 0
        os = ''
        host&.os&.each do |os_match|
          next unless os_match.accuracy > accuracy
          os = os_match.name
          accuracy = os_match.accuracy
        end
        client.os = os unless os.blank?
        client.save
      rescue => exception
        puts "Failed to get os_info ->"
        puts "host => #{host}"
        puts "client => #{client}"
        puts "exception => #{exception}"
      end
    end
  end

  # extract the highest probability system types (e.g. printers, routers, etc.)
  def os_type(host, client)
    begin
      cpe = ''
      type = ''
      accuracy = 0
      host.os && host.os.classes.each do |os_class|
        next unless os_class.accuracy > accuracy
        begin
          cpe = os_class.cpe.first
        rescue => exception
          puts "Failed to get cpe for os_type"
        end
        type = os_class.type
        accuracy = os_class.accuracy
      end
      client.cpe = cpe unless cpe.blank?
      client.ostype = type unless type.blank?
      client.save
    rescue => exception
      puts "Failed to get os_type ->"
      puts "host => #{host}"
      puts "client => #{client}"
      puts "exception => #{exception}"
    end
  end

  def ports(host, db_client)
    begin
      host.ports.each do |port|
        next unless port.state == :open
        db_port = Port.where(client_id: db_client.id, number: port.number).first_or_create
        db_port.client_id = db_client.id
        db_port.number = port.number
        if port.service.present?
          db_port.service = "#{port.service.ssl? ? 'ssl/' : ''}#{port.service.name}" unless db_port.sv
          if port.service.product.present?
            db_port.description = port.service.product
            db_port.description += ' ' + port.service.version if port.service.version.present?
            db_port.sv = true
          end
        end
        db_port.save
        port&.scripts&.each_value do |script|
          parse_script(script, db_client, db_port)
        end
      end
    rescue => exception
      puts "Failed to get ports ->"
      puts "host => #{host}"
      puts "client => #{db_client}"
      puts "exception => #{exception}"
    end
  end

  # analyzes a single nmap script and assigns it to the correct one port or client. 
  # Additional functions are called to parse special values from the script data (e.g. special flags, vulns). 
  # Since only a few scripts support an output format that can be processed cleanly by automation, the logig is divided into two almost identical solutions. 
  #   first: clean parsing with hash tables (exception, since rarely present).
  #   second: unclean parsing of blob data (default, since always present).
  def parse_script(script, db_client, db_port=nil)
    begin
      
      # the "if-block" is the preferred way to parse the nmap script data, since the individual entries are mapped into hash tables. 
      # unfortunately, only a few scripts use the form for XML
      if script&.data&.present?
        # initiate the DB-Object (Output for a Client or a Port Script)
        db_output = if db_port.present?
          Output.where(port_id: db_port.id, name: "#{script.id}:DATA").first_or_create
        else
          Output.where(client_id: db_client.id, name: "#{script.id}:DATA").first_or_create
        end
        script&.data&.default = '' if script&.data&.is_a?(Hash)
        db_output.value = YAML.dump(script&.data).lines[1..-1].join #remove the first line ("---\n")
        db_output.save
        find_vuln_from_data(db_client, script.id, script&.data)
        find_flags_from_data(db_client, script.id, script&.data)
      end

      # the "if-block" is the unclean way to parse the data of the nmap script, because a whole text formatted differently by each script is processed. 
      # unfortunately only a few scripts use a form which can be put into a key-value format automatically
      if script&.output&.present? # use default nmap output as that given from nmap (with spaces eg). this is only the falback if no data array available
        # initiate the DB-Object (Output for a Client or a Port Script)
        db_output = if db_port.present?
          Output.where(port_id: db_port.id, name: script.id).first_or_create
          else
          Output.where(client_id: db_client.id, name: script.id).first_or_create
          end
        db_output.value = script.output
        db_output.save
        find_vuln_from_output(db_client, script.id, script.output)
        find_flags_from_output(db_client, script.id, script.output)
      end

      

    rescue => exception
      puts "[!] Failed to parse script '#{script.id}' ->"
      puts "db_client => #{db_client}"
      puts "db_port => #{db_port}" if db_port
      puts "exception => #{exception}"
    end
  end


  def groups(client)
    unknown = Group.where(name: 'Unknown').first_or_create(mod: false, icon: '<i class="fas fa-desktop"></i>')
    @cpe_helper.group(client).each do |group_name|
      group = Group.where(name: group_name).first_or_create(mod: false, icon: @cpe_helper.icon(client))
      group.clients << client unless group.clients.find_by(id: client.id).present?
      if client.groups.count > 1
        unknown.clients.delete client if unknown.clients.find_by(id: client.id).present?
      end
      group.save
    end
  end

  def set_label(client, labeltext)
    client.labels << Label.find_by_name(labeltext) unless client.labels.find_by_name(labeltext).present?
    client.save
  end
  
  # set flags for known best practice scripts
  def find_flags_from_data(client, script_name, script_values)
    return if script_values.blank?
    # todo # zum testen in welchem script **data** man gelandet ist
    begin
      case script_name
      when 'http-ntlm-info', 'rdp-ntlm-info', 'ms-sql-ntlm-info'
        hostname = script_values['DNS_Computer_Name']
        hostname = script_values['NetBIOS_Computer_Name'] if hostname.blank?
        client.hostname = hostname unless hostname.blank?
        client.save
      when 'ftp-anon'
        # todo: need more research to check if the detection work anymore
        set_label(client, 'Anonymous FTP') if script_values.include? 'Anonymous FTP login allowed'
      when 'winrm'
        # todo: seems not work anymore. need more targets to check the detection
        set_label(client, 'WinRM') if script_values.include? 'WinRM service detected'
      when 'smb-os-discovery'
        # todo: need more research to check if the detection work anymore
        smb_os(client, script_values)
      when 'smb-security-mode'
        # todo: need more research to check if the detection work anymore
        set_label(client, 'SMB Signing') if script_values['message_signing'].casecmp('disabled').zero?
        set_label(client, 'SMB guest user') if script_values['account_used'].casecmp('guest').zero? && script_values['authentication_level'].casecmp('user').zero?
      end
    rescue => exception
      puts "[!] Failed to special_script_values from script '#{script_name}' ->"
      puts "client => #{client}"
      puts "script_values => #{script_values}"
    end
  end
  def find_flags_from_output(client, script_name, script_output)
    return if script_output.blank?
    # todoo # zum testen in welchem script **output** man gelandet ist
    begin
      case script_name
      when 'ftp-anon'
        # todo: need more research to check if the detection work anymore
        set_label(client, 'Anonymous FTP') if script_output.include? 'Anonymous FTP login allowed'
      when 'winrm'
        # todo: seems not work anymore. need more targets to check the detection
        set_label(client, 'WinRM') if script_output.include? 'WinRM service detected'
      when 'nbstat'
        script_output&.lines&.first&.split(',').each do |entry|
          entry.strip!
          # set hostname if can be parsed from nbstat and ignore if known hostname includes dots 
          # (the dot indicates that there is already a valid hostname e.g. from a ntlm / smb script which should be ranked higher)
          if entry.downcase.start_with? 'netbios name:'
            unless client.hostname.include? '.'
              hostname = entries&.first&.split(':')&.last&.strip
              client.hostname = hostname if hostname.present?
            end 
          elsif entry.downcase.start_with? 'netbios mac:'
            # split mac and vendor
            mac_vendor = entry.split(':')[1].split(' ', 2)
            # format to mac linke 0A:9F:0A:9F:0A:9F
            client.mac = mac_vendor[0].upcase.scan(/.{2}/).join ':' if mac_vendor[0]&.match /^([0-9A-Fa-f]{12})$/ 
            # extract den vendor / remove '(' & ')'
            client.vendor = mac_vendor[1][1..-2] if mac_vendor[1]&.match /^\(.+\)$/
          end
        end
      when 'smb-os-discovery'
        # todo: need more research to check if the detection work anymore
        smb_os(client, script_values)
      when 'smb-security-mode'
        # todo: need more research to check if the detection work anymore
        set_label(client, 'SMB Signing') if script_values['message_signing'].casecmp('disabled').zero?
        set_label(client, 'SMB guest user') if script_values['account_used'].casecmp('guest').zero? && script_values['authentication_level'].casecmp('user').zero?
      end
    rescue => exception
      puts "[!] Failed to special_script_values from script '#{script_name}' ->"
      puts "client => #{client}"
      puts "script_values => #{script_values}"
    end
  end

  def find_vuln_from_data(client, script_name, script_values)
    puts "need more vuln-scripts with script.data to test code!!"

    # script.output.lines[1] == "  VULNERABLE:\n" # nmap -sV --version-light --script ssl-poodle -p 443 HOST
    # script.data ->> no vuln flags

=begin
    # vulns.STATE.NOT_VULN
    # vulns.STATE.LIKELY_VULN
    # vulns.STATE.VULN
    # vulns.STATE.EXPLOIT
    if script_values.is_a?(Hash)
      begin
        vuln = []
        likely = []
        byebug
        script_values.each_pear do |sv_key, sv_value|

        script_values.each do |sv_value|
          byebug
          begin
            state = sv_value['state']
            if state
              case state.downcase
              when 'vulnerable'
                vuln << sv_key.to_s
              when 'likely vulnerable'
                likely << sv_key.to_s
              end
            end
          rescue => exception
            puts "[!] Failed to state from find_vuln_from_data single vuln ->"
            puts "sv_key => #{sv_key}"
            puts "sv_value => #{sv_value}"
          end
        end
      rescue => exception
        puts "Failed to state from find_vuln_from_data script ->"
        puts "script_name => #{script_name}"
        puts "script_values => #{script_values}"
      end
      set_vuln_label(client, script_name, vuln, false)
      set_vuln_label(client, script_name, likely, true)
    end
=end
  end

  def find_vuln_from_output(client, script_name, script_output)
    puts "need more vuln-scripts without script.data to test code!!"
  end

  def set_vuln_label(client, script_name, vulns, likely)
    return if vulns.empty?
    client.labels << Label.where(
      :name => "#{script_name}",
      :description => "Generated label: #{likely ? 'Likely vulnerable' : 'Vulnerable'} to '#{vulns.join("', '")}'",
      :priority => likely ? 'warning' : 'danger' ).first_or_create
    client.save
  end

  def smb_os(client, data)
    # set_label(client, 'Null Session') if data['os'].present?
    hostname = data['fqdn']
    hostname = data['server'].gsub('\\x00', '') if hostname.blank?
    client.hostname = hostname unless hostname.blank?
    cpe = data['cpe']
    client.cpe = cpe unless cpe.blank?
    os = data['lanmanager']
    client.os = os unless os.blank?
  end
end
