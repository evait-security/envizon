class ScanJob
  require 'nmap_parser'
  include SuckerPunch::Job
  workers 1

  def perform(command, scan, user)
    ActiveRecord::Base.connection_pool.with_connection do
      num_workers =  user.settings.find_by_name('parallel_scans').value.to_i
      # rm? will be overwritten in parser
      scan.startdate = Time.now
      scan.save
      command.run(scan)
      scan.enddate = Time.now
      scan.save
      ScanParseJob.perform_async(command.file_name, scan, user)
    end
  end
end
