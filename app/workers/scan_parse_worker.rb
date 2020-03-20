class ScanParseWorker
  require 'nmap_parser'
  include Sidekiq::Worker
  sidekiq_options queue: 'single'

  def perform(args)
    ActiveRecord::Base.connection_pool.with_connection do
      scan = Scan.find(args['scan_id'])
      user = User.find(args['user_id'])
      #num_workers = user.settings.find_by_name('parallel_scans').value.to_i

      nmap = NmapParser.new(args['xmlpath'])
      nmap.parse
      scan.command, scan.startdate = *nmap.result
      scan.enddate = scan.startdate if scan.enddate.blank?
      scan.file = args['xmlpath']
      scan.save
      user.scans << scan
      user.save
      ActionCable.server.broadcast 'notification_channel', message: "Scan '#{scan.name}' Part #{args['run_counter']}/#{args['max_run_counter']} finished"
    end
  end
end
