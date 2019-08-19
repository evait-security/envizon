class ScanWorker
  require 'nmap_parser'
  include Sidekiq::Worker
  sidekiq_options queue: 'scan'

  def perform(args)
    ActiveRecord::Base.connection_pool.with_connection do

      command = NmapCommand.new(args['command'], args['user_id'], args['target'])
      scan = Scan.new(name: args['scan_name'], user_id: args['user_id'])
      scan.command = 'Scan in progress…'
      scan.save

      #num_workers =  user.settings.find_by_name('parallel_scans').value.to_i
      # rm? will be overwritten in parser
      scan.startdate = Time.now
      scan.save
      command.run(scan)
      scan.enddate = Time.now
      scan.save
      args_parse = {
        'xmlpath' => command.file_name, 
        'scan_id' => scan.id, 
        'user_id' => args['user_id']
      }
      ScanParseWorker.perform_async(args_parse)
    end
  end
end
