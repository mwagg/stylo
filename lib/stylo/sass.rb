module Stylo
  module Sass
    def self.extended(base)
      require 'sass'
    end

    def process_asset(asset)
      combined_content = super(asset)

      if (File.extname(asset) == '.css')
        ::Sass::Engine.new(combined_content, {:syntax => :scss}).render
      else
        combined_content
      end
    end

    def get_file_content(asset_path)
      sass_path = asset_path.sub('.css', '.scss')

      if File.exists? sass_path
        File.read(sass_path)
      else
        super(asset_path)
      end
    end
  end
end