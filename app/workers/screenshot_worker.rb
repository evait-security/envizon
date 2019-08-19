class ScreenshotWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'background'
  
  def perform(args)
    ActiveRecord::Base.connection_pool.with_connection do
      #num_workers = user.settings.find_by_name('parallel_scans').value.to_i
      #sleep 6

      #ScreenshotWorker.perform_async(args['port_id'])
      begin
        Port.find(args['port_id']).screenshot
      rescue => exception
      end
    end
  end
end
