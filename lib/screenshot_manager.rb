require_relative 'screenshot_worker'
require_relative 'cask_enumerator'

class ScreenshotManager

  def run
    screenshot_directory = File.expand_path('../../shareware-screenshots', __FILE__)
    FileUtils.mkdir_p(screenshot_directory)

    screenshot_worker = ScreenshotWorker.new

    CaskEnumerator.enumerator.each do |cask_file, homepage|
      screenshot_filename = "#{screenshot_directory}/#{File.basename(cask_file, '.*')}.png"

      unless File.size?(screenshot_filename)
        screenshot_worker.take_screenshot(homepage, screenshot_filename)
      end
    end

    screenshot_worker.shutdown

    puts 'All screenshot captured...'
  end

end