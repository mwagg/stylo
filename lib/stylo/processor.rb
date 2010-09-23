module Stylo
  class Processor
    def initialize
      if Stylo::Config.enable_sass
        self.extend Stylo::Sass
      end
    end

    def get_stylesheet_path(stylesheet)
      File.join(Stylo::Config.public_location, stylesheet)
    end

    def process_stylesheet(stylesheet)
      stylesheet_path = get_stylesheet_path(stylesheet)

      file_content = get_file_content(stylesheet_path)
      if !file_content.nil?
        stylesheet_dir = File.dirname(stylesheet_path)

        process_requires file_content, stylesheet_dir
      else
        nil
      end
    end

    def get_file_content(stylesheet_path)
      return nil if !File.exist?(stylesheet_path)

      File.read(stylesheet_path)
    end

    private

    def process_requires(contents, base_path)
      contents.gsub /@import "(.*)";/ do |match|
        import_path = File.join(base_path, $1)
        import_content = get_file_content(import_path)

        if !import_content.nil?
          process_requires(import_content, base_path)
        else
          "@import \"#{$1}\";"
        end
      end
    end
  end
end