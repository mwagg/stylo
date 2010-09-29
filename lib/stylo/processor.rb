module Stylo
  class Processor
    def initialize
      if Stylo::Config.enable_sass
        self.extend Stylo::Sass
      end
    end

    def get_stylesheet_path(asset)
      File.join(Stylo::Config.public_location, asset)
    end

    def process_asset(asset)
      asset_path = get_stylesheet_path(asset)
      asset_extension = File.extname(asset_path)

      file_content = get_file_content(asset_path)
      if !file_content.nil?
        asset_dir = File.dirname(asset_path)

        import_regex = asset_extension == '.css' ? /@import "(.*)";/ : /\/\/\/include "(.*)";/

        process_requires file_content, asset_dir, import_regex
      else
        nil
      end
    end

    def get_file_content(asset_path)
      return nil if !File.exist?(asset_path)

      File.read(asset_path)
    end

    private

    def process_requires(contents, base_path, import_regex)
      contents.gsub import_regex do |match|
        import_path = File.join(base_path, $1)
        import_content = get_file_content(import_path)

        if !import_content.nil?
          process_requires(import_content, base_path, import_regex)
        else
          raise "Cannot find file to import '#{$1}'."
        end
      end
    end
  end
end