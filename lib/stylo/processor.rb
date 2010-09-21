module Stylo
  class Processor
    def process_stylesheet(stylesheet)
      File.read File.join(Stylo::Config.public_location, stylesheet)
    end
  end
end