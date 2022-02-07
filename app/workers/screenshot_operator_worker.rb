class ScreenshotOperatorWorker
  include Sidekiq::Worker

  # do not use the background que!!.
  # This is a Worker to manage secondary Workers.
  # if both use the the same que, this can plug them.
  sidekiq_options queue: 'default' # !

  def perform(args)
    ActiveRecord::Base.connection_pool.with_connection do
      if args.include? "clients"
        ports = Port.screenshotable.includes(:client).where('clients.id' => args['clients'], 'clients.archived' => false)
      else
        ports = Port.screenshotable.includes(:client).where('clients.archived' => false)
      end
      # if overwrite=false -> select only ports without image.
      ports = ports.reject { |p| p.image.attached? } unless args['overwrite']
      ports.each do |port|
        begin
          ScreenshotWorker.perform_async({ 'port_id' => port.id })
        rescue StandardError => e
          logger.warn "Exception in ScreenshotOperatorWorker: #{e.message}"
        end
      end
      # ScreenshotWorker.wait_until_finish
      ActionCable.server.broadcast 'notification_channel', message: 'Screenshot jobs scheduled'
    end
  end
end
