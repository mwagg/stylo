require 'sass'

module Stylo
  module PipelineSteps
    class Sass
      def call(response)
        return if response.has_content? || response.extension != '.css'
        content = AssetLoader.load_content(response.path.gsub('.css', '.scss'))
        return if content.nil?

        combined_content = Combiner.new(File.dirname(response.path), REQUIRE_PATTERN).process(content)
        processed_content = ::Sass::Engine.new(combined_content, {:syntax => :scss}).render

        response.set_body(processed_content, :css)
      end
    end
  end
end