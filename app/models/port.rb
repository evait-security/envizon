class Port < ApplicationRecord
  validates :number, presence: true
  belongs_to :client
  has_many :outputs, dependent: :destroy
  has_one_attached :image

  def service_short
    if self.service.include?('http')
      return "https" if self.service.include?('ssl') || self.service.include?('https')
      return "http"
    end
    return "vnc" if self.service.include?('vnc')
    return nil
  end

  def url_ip
    "#{self.service_short}://#{self.client.ip}:#{self.number}/"
  end

  def url_host
    return nil if self.client.hostname.empty?
    "#{self.service_short}://#{self.client.hostname}:#{self.number}/"
  end

  def screenshot
    case self.service_short
    when 'http', 'https'
      wd = Selenium::WebDriver.for :remote, url: 'http://localhost:4444/wd/hub', desired_capabilities: SELENIUM_CAPS
      wd.manage.timeouts.page_load = 10
      wd.navigate.to self.url_ip
      wd.manage.window.resize_to(1920, 1080)
      img =  wd.screenshot_as(:png)
    end

    self.image.attach(io: StringIO.new(img), filename: "screenshot_#{self.client.ip}_#{self.number}.png", content_type: 'image/png') if img
  end

end