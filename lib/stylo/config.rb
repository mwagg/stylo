module Stylo
  class Config
    class << self
      attr_accessor :asset_location

      def pipeline
        [Stylo::PipelineSteps::Stylesheet.new,
         Stylo::PipelineSteps::Javascript.new,
         Stylo::PipelineSteps::Sass.new,
         Stylo::PipelineSteps::Caching.new]
      end
    end
  end
end