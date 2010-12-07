module Stylo
  class Config
    class << self
      def options
        @options ||= defaults.clone
      end

      def defaults
        {
          :css_combining_enabled => true,
          :js_combining_enabled => true,
          :js_minifying_enabled => true,
          :css_minifying_enabled => true
        }
      end

      def pipeline
        [Stylo::PipelineSteps::Stylesheet.new,
          Stylo::PipelineSteps::StylesheetMinifying.new,
          Stylo::PipelineSteps::Javascript.new,
          Stylo::PipelineSteps::JavascriptMinifying.new,
          Stylo::PipelineSteps::Caching.new]
      end

      def reset_to_default
        @options = defaults.clone
      end
    end

    reset_to_default
  end
end
