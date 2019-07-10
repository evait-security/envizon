class ScreenshotJob
  include SuckerPunch::Job
  workers 3

  def perform(port, user)
    ActiveRecord::Base.connection_pool.with_connection do
      #num_workers = user.settings.find_by_name('parallel_scans').value.to_i
      begin
        port.screenshot
      rescue => exception
      end
    end
  end

  # result nil if job nox exist, or hash_array like
  # => {"processed"=>400, "failed"=>0, "enqueued"=>0}
  def self.wait_until_finish
    return nil unless SuckerPunch::Queue.stats.has_key? self.to_s
    begin
      sleep 3
    end while SuckerPunch::Queue.stats[self.to_s]['workers']['busy'] > 0
    return SuckerPunch::Queue.stats[self.to_s]['jobs']
  end
end
