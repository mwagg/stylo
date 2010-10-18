module Stylo
  class Config
    class << self
      attr_accessor :asset_location, :css_combining_enabled, :javascript_combining_enabled

      def pipeline
        [Stylo::PipelineSteps::Stylesheet.new,
         Stylo::PipelineSteps::Javascript.new,
         Stylo::PipelineSteps::Sass.new,
         Stylo::PipelineSteps::Caching.new]
      end

      def reset_to_default
        self.css_combining_enabled = true
        self.javascript_combining_enabled = true
      end
    end

    reset_to_default
  end
end