class ScanParseWorker
  require 'nmap_parser'
  include Sidekiq::Worker

  def perform(args)
    ActiveRecord::Base.connection_pool.with_connection do
      scan = Scan.find(args['scan_id'])
      user = Scan.find(args['user_id'])
      #num_workers = user.settings.find_by_name('parallel_scans').value.to_i

      nmap = NmapParser.new(args['xmlpath')
      nmap.parse
      scan.command, scan.startdate = *nmap.result
      scan.enddate = scan.startdate if scan.enddate.blank?
      scan.file = xmlpath
      scan.save
      user.scans << scan
      user.save
      ActionCable.server.broadcast 'notification_channel', message: 'Scan finished'
    end
  end
end
