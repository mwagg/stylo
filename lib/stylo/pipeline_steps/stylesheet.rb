module Stylo
  module PipelineSteps
    REQUIRE_PATTERN = /@import "(.*)";/

    class Stylesheet
      def call(response)
        raise 'You must set the asset location (Stylo::Config.options[:asset_location]) before stylo can be used.' if !Config.options[:asset_location]

        return if response.has_content? || response.extension != '.css'
        return unless content = AssetLoader.load_content(response.path)

        if Config.options[:css_combining_enabled]
          content = Combiner.new(REQUIRE_PATTERN).process(File.dirname(response.path), content)
        end

        response.set_body content, :css
      end
    end
  end
end
