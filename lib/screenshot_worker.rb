require 'thread'
require_relative 'screenshot_builder'

class ScreenshotWorker

  POISON_PILL = Object.new
  MAX_THREADS = 20

  def initialize
    @incoming_queue = Queue.new
    @worker_threads = create_threads
  end

  def take_screenshot(url, screenshot_filename)
    @incoming_queue << [url, screenshot_filename]
  end

  def shutdown
    MAX_THREADS.times { @incoming_queue << POISON_PILL }
    @worker_threads.each {|worker_thread| worker_thread.join }
  end

  private

  def create_threads
    MAX_THREADS.times.map { create_thread }
  end

  def create_thread
    Thread.new do
      screenshot_builder = ScreenshotBuilder.new
      while (data = @incoming_queue.pop) != POISON_PILL
        url, screenshot_filename = *data

        puts "Capture #{File.basename(screenshot_filename)}..."

        screenshot_builder.take_screenshot(url, screenshot_filename)
      end

      screenshot_builder.close
    end
  end
end