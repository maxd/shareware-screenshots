require 'watir'
require 'watir-webdriver'

Watir.default_timeout = 15

class ScreenshotBuilder

  def initialize
    @browser = Watir::Browser.new
    @browser.window.resize_to(1366, 768)
  end

  def take_screenshot(url, screenshot_filename)
    try_again 3, "Goto #{url}" do
      @browser.goto(url)
    end

    sleep(5)

    try_again 3, "Take screenshot of #{url}" do
      @browser.screenshot.save(screenshot_filename)
    end

    try_again 3, 'Goto about:blank' do
      @browser.goto('about:blank')
    end
  rescue => e
    puts "!!! Skip #{url}"
    puts e.message
  end

  def close
    @browser.close
  end

  private

  def try_again(count, title, &block)
    begin
      yield
    rescue Net::ReadTimeout
      if count > 0
        puts "Try again: #{title}..."

        sleep 3

        try_again(count - 1, title, &block)
      else
        raise :skip
      end
    end
  end

end