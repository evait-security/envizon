class ScanParseJob
  require 'nmap_parser'
  include SuckerPunch::Job
  workers 1

  def perform(xmlpath, scan, user)
    ActiveRecord::Base.connection_pool.with_connection do
      num_workers = user.settings.find_by_name('parallel_scans').value.to_i
      nmap = NmapParser.new(xmlpath)
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
