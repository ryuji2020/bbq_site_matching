Capybara.javascript_driver = :selenium_chrome_headless

Capybara.register_driver :selenium_chrome_headless do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--no-sandbox'
  browser_options.args << '--disable-gpu'
  browser_options.add_argument('window-size=1440,990')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end
