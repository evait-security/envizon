class ScreenshotJob
  include SuckerPunch::Job

  def perform(overwrite)
    ActiveRecord::Base.connection_pool.with_connection do
      ports = Port.all.select{ |p| p.is_screenshotable?}
      # if overwrite=false -> select only ports without image. 
      ports = ports.select{ |p| !p.image.attached? } unless overwrite
      ports.each{ |p| p.screenshot }
      ActionCable.server.broadcast 'notification_channel', message: 'Screenshot-Job finished'
    end
  end
end
