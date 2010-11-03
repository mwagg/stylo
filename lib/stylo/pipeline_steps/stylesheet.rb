module Stylo
  module PipelineSteps
    REQUIRE_PATTERN = /@import "(.*)";/

    class Stylesheet
      def call(response)
        return if response.has_content? || response.extension != '.css'
        return unless content = AssetLoader.load_content(response.path)

        if Config.css_combining_enabled
          content = Combiner.new(REQUIRE_PATTERN).process(File.dirname(response.path), content)
        end

        response.set_body content, :css
      end
    end
  end
end
