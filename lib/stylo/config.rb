module Stylo
  class Config
    class << self
      attr_accessor :asset_location, :enable_sass

      def reset_to_default
        self.enable_sass = false
      end

      def pipeline
        [Stylo::PipelineSteps::Stylesheet.new,
         Stylo::PipelineSteps::LegacyProcessor.new,
         Stylo::PipelineSteps::Sass.new,
         Stylo::PipelineSteps::Caching.new]
      end
    end
  end
end