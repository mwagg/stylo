module Stylo
  class Processor
    def process_stylesheet(stylesheet)
      stylesheet_path = File.join(Stylo::Config.public_location, stylesheet)

      if File.exist? stylesheet_path
        stylesheet_dir = File.dirname(stylesheet_path)

        File.open(stylesheet_path, 'r') do |file|
          file_content = file.read

          return process_requires file_content, stylesheet_dir
        end
      else
        nil
      end
    end

    private

    def process_requires(contents, base_path)
      contents.gsub /@import "(.*)";/ do |match|
        import_path = File.join(base_path, $1)
        if File.exists? import_path
          process_requires(File.read(import_path), base_path)
        else
          "@import \"#{$1}\";"
        end
      end
    end
  end
end