module Stylo
  module PipelineSteps
    class JavascriptMinifying
      def call(response)
        if Config.javascript_minifying_enabled and response.extension == '.js' and response.has_content?
          response.set_body(JSMin.new(response.body).minify, :javascript)
        end
      end
    end
  end
end