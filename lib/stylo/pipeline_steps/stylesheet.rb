module Stylo
  module PipelineSteps
    REQUIRE_PATTERN = /@import "(.*)";/

    class Stylesheet
      def call(response)
        return if response.has_content? || response.extension != '.css'
        return unless content = AssetLoader.load_content(response.path)
        combined_content = Combiner.new(File.dirname(response.path), REQUIRE_PATTERN).process(content)

        response.set_body combined_content, :css
      end
    end
  end
end