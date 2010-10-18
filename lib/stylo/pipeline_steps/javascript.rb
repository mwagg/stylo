module Stylo
  module PipelineSteps
    class Javascript
      REQUIRE_PATTERN = /\/\/\/require "(.*)";/

      def call(response)
        return if response.has_content? || response.extension != '.js'
        return unless content = AssetLoader.load_content(response.path)
        combined_content = Combiner.new(File.dirname(response.path), REQUIRE_PATTERN).process(content)

        response.set_body combined_content, :javascript
      end
    end
  end
end
