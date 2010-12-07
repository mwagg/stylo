module Stylo
  module PipelineSteps
    class StylesheetMinifying
      def call(response)
        if Config.options[:css_minifying_enabled] and response.extension == '.css' and response.has_content?
          minified = CssMinifier.minify(response.body)
          response.set_body minified, :css
        end
      end
    end
  end
end
