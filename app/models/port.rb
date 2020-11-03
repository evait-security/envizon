# frozen_string_literal: true

class Port < ApplicationRecord
  validates :number, presence: true
  belongs_to :client
  has_many :outputs, dependent: :destroy
  has_one_attached :image
  has_many :notes, as: :noteable

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
      # wd = Selenium::WebDriver.for :remote, url: 'http://selenium:4444/wd/hub',
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--ignore-certificate-errors')
      options.add_argument('--disable-popup-blocking')
      options.add_argument('--disable-translate')
      options.add_argument('--whitelisted-ips')
      options.add_argument('--disable-extensions')
      # options.AddArgument('--headless')
      # options.AddArgument('--no-sandbox');
      wd = Selenium::WebDriver.for :remote, url: 'http://127.0.0.1:4444/wd/hub',
                                            desired_capabilities: SELENIUM_CAPS,
                                            options: options
      wd.manage.timeouts.page_load = 10
      wd.navigate.to url_ip
      sleep 5
      wd.manage.window.resize_to(1920, 1080)
      img = wd.screenshot_as(:png)
      # NOTE: if we find out performance suffers by always using a new instance,
      # we could alternatively use a global-ish wd object (as in wd ||= Selenium::WebDriver),
      # initialized ...somewhere else, or just in the initializer:
      # SELENIUM = Selenium::WebDriver.for :remote, url: 'http://localhost:4444/wd/hub', desired_capabilities: caps
      # wd = SELENIUM
      # => in which case we'd probably have to use wd.close, to only close the tab/window, assuming that doesn't destroy
      # Selenium::WebDriver instance as well(?)
      wd.quit
    end

    return unless img

    image.attach(io: StringIO.new(img),
                 filename: "screenshot_#{client.ip}_#{number}.png",
                 content_type: 'image/png')
  end
end
