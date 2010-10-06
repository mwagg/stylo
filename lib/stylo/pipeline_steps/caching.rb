module Stylo
  module PipelineSteps
    class Caching
      def call(response)
        if response.has_content?
          response.set_header('Cache-Control', 'public, max-age=86400')
        end
      end
    end
  end
end