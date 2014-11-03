class CaskEnumerator

  def self.enumerator
    Enumerator.new do |y|
      casks_directory = File.expand_path('../../vendor/homebrew-cask/Casks', __FILE__)
      cask_files = Dir["#{casks_directory}/*.rb"]
      cask_files.each do |cask_file|
        file_content = File.read(cask_file)

        if /homepage\s+['"](?<homepage>.+)['"]/ =~ file_content && /^(grooveshark)/ !~ File.basename(cask_file)
          y.yield(cask_file, homepage)
        end
      end
    end
  end

end