class NmapCommand
  def initialize(options, user_id, targets = [])
    @timestamp = Time.now.strftime('%Y%m%d_%H%M%S_%L')
    @run_counter = 0

    @user_id = user_id
    begin
      @simultane_targets = @user.find(@user_id).settings.where(name: 'max_host_per_scan').first_or_create.value.to_i
      @simultane_targets = @simultane_targets > 0 ? @simultane_targets : 0
    rescue
      @simultane_targets = 0
    end

    #split targets
    targets_list = targets.respond_to?(:split) ? targets.split(' ') : targets #what if it is not respond to split?
    ip_targets = []
    host_targets = []
    targets_list.each do | address |
      begin
        ip_targets.push(IPAddress.parse address)
      rescue ArgumentError
        # not a CIDR range
        host_targets.push address
      end
    end

    ip_targets = IPAddress::IPv4::summarize(*ip_targets)

    # split Targets to array
    if @simultane_targets > 0
      @all_targets = host_targets.each_slice(@simultane_targets).to_a
      # get all single ips as list
      unless ip_targets.blank?
        ip_targets = ip_targets.map{|i| i.hosts.blank? ? i : i.hosts}.flatten
        # .hosts do not split to single ips, because its don't set the subnet to /32
        ip_targets = ip_targets.map do |single|
          single.prefix = 32
          single
        end
      end
      # fill last array to max
      if(!@all_targets.blank? && !ip_targets.blank? && @all_targets.last.length < @simultane_targets)
        ips = address_array_to_string_array(ip_targets.shift(@simultane_targets - @all_targets.last.length))
        @all_targets.last.push *ips
      end

      unless ip_targets.blank?
        # map ips to compact string arrays and apand to @all_targets
        @all_targets += ip_targets.each_slice(@simultane_targets).to_a.map{|i| address_array_to_string_array(i)}
      end
    else
      # all hosts at same scan
      @all_targets = host_targets + address_array_to_string_array(ip_targets)
    end

    @max_run_counter = @all_targets.length

    # file names
    FileUtils.mkdir_p(Rails.root.join('app', 'nmap', 'output'))
    gen_exclude_file(user_id)
    @options = args(options)
  end

  def address_array_to_string_array(ip_address_list)
    IPAddress::IPv4.summarize(*ip_address_list).map(&:to_string)
  end

  def next_targets
    @targets
  end

  def gen_exclude_file(user_id)
    exclude_hosts = Socket.ip_address_list.map do |ip|
      ipaddr = IPAddress(ip.ip_address)
      ipaddr.respond_to?(:compressed) ? ipaddr.compressed : ipaddr.address
    end

    host = User.find(user_id).settings.where(name: 'exclude_hosts').first_or_create.value
    exclude_hosts += YAML.safe_load(host).lines if host.present?

    exclude_hosts = exclude_hosts.uniq.sort

    path = Rails.root.join('app', 'nmap', 'output', @timestamp + '_exclude.txt')
    exclude_file = File.open(path, 'w')
    exclude_hosts.each { |h| exclude_file.puts h }
    exclude_file.close

    wait_for_file(path)
    @exclude_file = path
  end

  def wait_for_file(file_name)
    sleep 0.5 until File.exist? file_name
  end

  def args(options)
    options = options.split
    %w[nmap sudo -iL -oX -oN -oS -oG].each { |o| options.delete o }

    ['--stats-every', '10s',
     '--excludefile',
     @exclude_file.to_s].each { |o| options.push o }
  end



  def run_worker(scan)
    scan.startdate = Time.now
    scan.save

    @all_targets.each.with_index(1) do |targets, index|

      options = @options
      file_name = Rails.root.join('app', 'nmap', 'output', "#{@timestamp}_output#{index}-#{@max_run_counter}.xml")
      options.push '-oX'
      options.push file_name.to_s
      options.push targets
      options.flatten!
      cmd = 'nmap'

      args_parse = {
        'scan_id' => scan.id,
        'user_id' => @user_id,
        'cmd' => cmd,
        'options' => options.join(' '),
        'run_counter' => index,
        'filename' => file_name.to_s,
        'max_run_counter' => @max_run_counter
      }
      ScanWorker.perform_async(args_parse)

    end
  end
=begin
  def run(scan)
    # target mapping
    file_name = nil
    # todo work with targetfiles
    #targets = @target_file.present? ? ['-iL ', @target_file.to_s] : @targets
    if !@all_targets.blank? && @run_counter < @max_run_counter
      cur_run_counter = @run_counter
      @run_counter += 1
      options = @options
      file_name = Rails.root.join('app', 'nmap', 'output', "#{@timestamp}_output#{(cur_run_counter +1)}-#{@max_run_counter}.xml")
      options.push '-oX'
      options.push file_name.to_s
      options.push @all_targets[cur_run_counter]
      options.flatten!
      env = ENV
      cmd = 'nmap'
      unless Process.uid.zero? # && askpass # wut?
        env = askpass
        options.unshift 'nmap'
        options.unshift '-A'
        cmd = 'sudo'
      end
      return_value = nil
      Open3.popen3(env, cmd, *@options) do |_stdin, stdout, _stderr, thread|
        stdout.each do |l|
          l.match(/About (.*) done/) do |m|
            c = m.captures.first
            scan.status = c.match(/\A(\d+)\.\d+\%\Z/).captures.first.to_i
            scan.save
            next unless User.first.settings.where(name: 'global_notify').first.value.include? "true"
            message = "Scan #{scan.name} - #{(cur_run_counter +1)}/#{@max_run_counter} is #{c} done."
            ActionCable.server.broadcast 'notification_channel', message: message
          end
          # TODO: message on fail?
          # exception?
          # parse nmap errors if it doesn't like the options
        end
        #
        # let's do some generic error handling in the meantime:
        return_value = thread.value
      end
      return file_name if return_value.success?
      message = "Nmap threw an error: #{return_value.exitstatus}!"
      ActionCable.server.broadcast 'notification_channel', message: message
      scan.command = 'Scan failed.'
      scan.save
    else # no more targets
      message = "No targets to scan"
      ActionCable.server.broadcast 'notification_channel', message: message
      scan.command = 'Scan failed.'
      scan.save
    end
  end
=end

  #attr_reader :file_name
  attr_reader :run_counter
  attr_reader :max_run_counter
end
