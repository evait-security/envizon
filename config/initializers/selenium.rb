# config.chrome_args = [
# '--headless',
# '--hide-scrollbars',
# '--ignore-certificate-errors',
# '--disable-gpu',
# # '--no-sandbox',
# '--disable-popup-blocking',
# '--disable-translate',
# "--window-size=#{config.width},#{config.height}",
# '--enable-font-antialiasing',
# '--font-cache-shared-handle[6]'
# ]
# end
caps = Selenium::WebDriver::Remote::Capabilities.chrome
caps['javascriptEnabled'] = true
caps['acceptSslCerts'] = true
SELENIUM = Selenium::WebDriver.for :remote, url: 'http://localhost:4444/wd/hub', desired_capabilities: caps
