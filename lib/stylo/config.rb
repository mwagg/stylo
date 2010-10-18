module Stylo
  class Config
    class << self
      attr_accessor :asset_location, :combining_enabled

      def pipeline
        [Stylo::PipelineSteps::Stylesheet.new,
         Stylo::PipelineSteps::Javascript.new,
         Stylo::PipelineSteps::Sass.new,
         Stylo::PipelineSteps::Caching.new]
      end

      def reset_to_default
        self.combining_enabled = true
      end
    end

    reset_to_default
  end
end