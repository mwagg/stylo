module Stylo
  class Processor
    def process_stylesheet(stylesheet)
      stylesheet_path = File.join(Stylo::Config.public_location, stylesheet)

      if File.exist? stylesheet_path
        File.read stylesheet_path
      else
        nil
      end
    end
  end
end