require 'socket'
require 'open3'

class NmapCommand
  def initialize(options, user_id, targets = [], file = nil)
    @timestamp = Time.now.strftime('%Y%m%d_%H%M%S_%L')
    @targets = targets.respond_to?(:split) ? targets.split(' ') : targets
    @target_file = file
    FileUtils.mkdir_p(Rails.root.join('app', 'nmap', 'output'))
    @file_name = Rails.root.join('app', 'nmap', 'output', @timestamp + '_output.xml')
    gen_exclude_file(user_id)
    @options = args(options)
  end

  def gen_exclude_file(user_id)
    exclude_hosts = []

    Socket.ip_address_list.each { |ip| exclude_hosts.push(ip.ip_address) }

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
    targets = @target_file.present? ? ['-iL ', @target_file.to_s] : @targets

    ['--stats-every', '10s',
     '-oX', @file_name.to_s, '--excludefile',
     @exclude_file.to_s, targets].each { |o| options.push o }

    options.flatten
  end

  def askpass
    env = ENV.clone
    env['SUDO_ASKPASS'] = if ENV['SUDO_ASKPASS'].present? && File.exist?(ENV['SUDO_ASKPASS'])
                            ENV['SUDO_ASKPASS']
                          elsif File.exist?('/usr/lib/ssh/x11-ssh-askpass')
                            '/usr/lib/ssh/x11-ssh-askpass'
                          else
                            ''
                          end
    # TODO: that was somewhat stupid. probably should only send out a message if
    # nmap itself returns privilege-related failure.
    # So basically: rewrite sudo handling
    # message = 'Couldn\'t get root privileges, please set SUDO_ASKPASS'
    # ActionCable.server.broadcast 'notification_channel', message: message
    env['SUDO_ASKPASS'].present? ? env : false
  end

  def run(scan)
    env = ENV
    cmd = 'nmap'
    unless Process.uid.zero? # && askpass # wut?
      env = askpass
      @options.unshift 'nmap'
      @options.unshift '-A'
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
          message = "Scan #{scan.name} is #{c} done."
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
    return if return_value.success?
    message = "Nmap threw an error: #{return_value.exitstatus}!"
    ActionCable.server.broadcast 'notification_channel', message: message
    scan.command = 'Scan failed.'
    scan.save
  end

  attr_reader :file_name
end
