SELENIUM_CAPS = Selenium::WebDriver::Remote::Capabilities.chrome
SELENIUM_CAPS[:javascriptEnabled] = true
SELENIUM_CAPS[:acceptSslCert] = true
SELENIUM_CAPS[:acceptInsecureCerts] = true
