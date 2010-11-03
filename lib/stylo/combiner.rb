module Stylo
  class Combiner
    def initialize(asset_directory, require_pattern)
      @require_pattern = require_pattern
      @asset_directory = asset_directory
    end

    def process(content)
      content.gsub @require_pattern do |match|
	raise "Cannot find referenced asset '#{$1}'." if !(content = AssetLoader.load_content(File.join(@asset_directory, $1)))
        process(content)
      end
    end
  end
end
