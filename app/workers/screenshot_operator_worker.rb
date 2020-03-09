class ScreenshotOperatorWorker
  include Sidekiq::Worker

  # do not use the background que!!. 
  # This is a Worker to manage secondary Workers. 
  # if both use the the same que, this can plug them.
  sidekiq_options queue: 'default' #!

  def perform(args)
    ActiveRecord::Base.connection_pool.with_connection do
      ports = Port.all.select{ |p| p.screenshotable?}
      # if overwrite=false -> select only ports without image. 
      ports = ports.select{ |p| !p.image.attached? } unless args['overwrite']
      ports.each do |port| 
        print port
        begin
          ScreenshotWorker.perform_async({'port_id' => port.id})
        rescue => exception
        end
      end
      #ScreenshotWorker.wait_until_finish
      ActionCable.server.broadcast 'notification_channel', message: 'Screenshot-Job finished'
    end
  end
end
