# frozen_string_literal: true

class Port < ApplicationRecord
  validates :number, presence: true
  belongs_to :client
  has_many :outputs, dependent: :destroy
  has_one_attached :image

  def screenshotable?
    case service_short
    when 'http', 'https'
      return true
    end
    false
  end

  def service_short
    if service.include?('http')
      return 'https' if service.include?('ssl') || service.include?('https')

      return 'http'
    end
    return 'vnc' if service.include?('vnc')

    nil
  end

  def url_ip
    "#{service_short}://#{client.ip}:#{number}/"
  end

  def url_host
    return nil unless client.hostname.present?

    "#{service_short}://#{client.hostname}:#{number}/"
  end

  def screenshot
    return unless screenshotable?

    case service_short
    when 'http', 'https'
      wd = Selenium::WebDriver.for :remote, url: 'http://selenium:4444/wd/hub',
                                            desired_capabilities: SELENIUM_CAPS
      wd.manage.timeouts.page_load = 10
      wd.navigate.to url_ip
      sleep 5
      wd.manage.window.resize_to(1920, 1080)
      img = wd.screenshot_as(:png)
    end

    return unless img

    image.attach(io: StringIO.new(img),
                 filename: "screenshot_#{client.ip}_#{number}.png",
                 content_type: 'image/png')
  end
end
