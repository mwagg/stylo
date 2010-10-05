module Stylo
  module PipelineSteps
    class LegacyProcessor
      def initialize
        @processor = Processor.new
      end

      def call(response)
        if response.path =~ /(\.css)|(\.js)\z/
          content = @processor.process_asset(response.path)

          if !content.nil?
            stylesheet_response(response, content, $1)
          end
        end
      end

      private

      def stylesheet_response(response, stylesheet_content, extension)
        content_type = extension == '.css' ? :css : :javascript

        response.set_body stylesheet_content, content_type
        response.set_header 'Cache-Control', 'public, max-age=86400'
      end
    end
  end
end