class ScanParseWorker
  require 'nmap_parser'
  include Sidekiq::Worker
  sidekiq_options queue: 'single'

  def perform(args)
    ActiveRecord::Base.connection_pool.with_connection do
      scan = Scan.find(args['scan_id'])
      user = User.find(args['user_id'])
      # num_workers = user.settings.find_by_name('parallel_scans').value.to_i

      nmap = NmapParser.new(args['xmlpath'])
      begin
        nmap.parse
        scan.command, scan.startdate = *nmap.result
        scan.enddate = scan.startdate if scan.enddate.blank?
        scan.file = args['xmlpath']
        scan.save
        user.scans << scan
        user.save
        # let's catch everything, because we want to just signal all kinds of failed scans
      rescue
        ActionCable.server.broadcast('notification_channel', { body: "Scan '#{scan.name}' Part #{args['run_counter']}/#{args['max_run_counter']} failed" })
      ensure
        FileUtils.rm_f(args['xmlpath'])
      end
      #{ message: "No URL was given", type: 'alert' }
      ActionCable.server.broadcast('notification_channel', { message: "Scan '#{scan.name}' Part #{args['run_counter']}/#{args['max_run_counter']} finished" , type: 'alert' })
    end
  end
end
