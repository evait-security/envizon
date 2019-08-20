class ScreenshotOperatorJob
  include SuckerPunch::Job
  workers 1

  def perform(overwrite, user)
    ActiveRecord::Base.connection_pool.with_connection do
      ports = Port.all.select{ |p| p.is_screenshotable?}
      # if overwrite=false -> select only ports without image. 
      ports = ports.select{ |p| !p.image.attached? } unless overwrite
      ports.each do |port| 
        begin
          ScreenshotJob.perform_async(port, user)
        rescue => exception
        end
      end
      ScreenshotJob.wait_until_finish
      ActionCable.server.broadcast 'notification_channel', message: 'Screenshot-Job finished'
    end
  end
end