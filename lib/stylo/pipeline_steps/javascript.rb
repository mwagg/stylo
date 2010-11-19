module Stylo
  module PipelineSteps
    class Javascript
      REQUIRE_PATTERN = /\/\/\/require "(.*)";/

      def call(response)
        raise 'You must set the asset location (Stylo::Config.options[:asset_location]) before stylo can be used.' if !Config.options[:asset_location]

        return if response.has_content? || response.extension != '.js'
        return unless content = AssetLoader.load_content(response.path)

        if Config.options[:js_combining_enabled]
          content = Combiner.new(REQUIRE_PATTERN).process(File.dirname(response.path), content)
        end

        response.set_body content, :javascript
      end
    end
  end
end
