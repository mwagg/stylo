module Stylo
  class Combiner
    def initialize(asset_directory, require_pattern)
      @require_pattern = require_pattern
      @asset_directory = asset_directory
    end

    def process(base_directory, content)
      content.gsub @require_pattern do |match|
        required_dir = File.dirname($1)
	required_dir = required_dir == '.' ? base_directory : File.join(base_directory, required_dir)

	raise "Cannot find referenced asset '#{$1}'." if !(content = AssetLoader.load_content(File.join(base_directory, $1)))
        process(required_dir, content)
      end
    end
  end
end
