module Stylo
  module PipelineSteps
    class Javascript
      REQUIRE_PATTERN = /\/\/\/require "(.*)";/

      def call(response)
        return if response.has_content? || response.extension != '.js'
        return unless content = AssetLoader.load_content(response.path)

        if Config.javascript_combining_enabled
          content = Combiner.new(File.dirname(response.path), REQUIRE_PATTERN).process(File.dirname(response.path), content)
        end

        response.set_body content, :javascript
      end
    end
  end
end
