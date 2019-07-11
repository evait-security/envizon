class ScreenshotOperatorWorker
  include Sidekiq::Worker

  def perform(args)
    ActiveRecord::Base.connection_pool.with_connection do
      ports = Port.all.select{ |p| p.is_screenshotable?}
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
