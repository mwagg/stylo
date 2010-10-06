module Stylo
  class Combiner
    def initialize(asset_directory, require_pattern)
      @require_pattern = require_pattern
      @asset_directory = asset_directory
    end

    def process(content)
      content.gsub @require_pattern do |match|
        process(AssetLoader.load_content(File.join(@asset_directory, $1)))
      end
    end
  end
end