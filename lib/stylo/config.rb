module Stylo
  class Config
    class << self
      attr_accessor :public_location, :enable_sass

      def reset_to_default
        self.enable_sass = false
      end

      def pipeline
        [Stylo::PipelineSteps::LegacyProcessor.new]
      end
    end
  end
end