class ScreenshotWorker
  include Sidekiq::Worker
  # do not use the background que!!.
  # This is a Worker to manage secondary Workers.
  # if both use the the same que, this can plug them.
  sidekiq_options queue: 'default' # !

  def perform(args)
    ActiveRecord::Base.connection_pool.with_connection do
      # num_workers = user.settings.find_by_name('parallel_scans').value.to_i
      # sleep 6

      # ScreenshotWorker.perform_async(args['port_id'])
      begin
        Port.find(args['port_id']).screenshot
      rescue StandardError => e
        logger.warn "Exception in ScreenshotWorker: #{e.message}"
      end
    end
  end
end
