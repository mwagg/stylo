module Stylo
  module Sass
    def self.extended(base)
      require 'sass'
    end

    def process_stylesheet(stylesheet)
      combined_content = super(stylesheet)

      ::Sass::Engine.new(combined_content, { :syntax => :scss }).render
    end

    def get_file_content(stylesheet_path)
      sass_path = stylesheet_path.sub('.css', '.scss')

      if File.exists? sass_path
        File.read(sass_path)
      else
        super(stylesheet_path)
      end
    end
  end
end