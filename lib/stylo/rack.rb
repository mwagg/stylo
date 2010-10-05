module Stylo
  class Rack
    def initialize(app)
      @app = app
      @processor = Processor.new
    end

    def call(env)
      path = env["PATH_INFO"]

      response = Response.new
      Stylo::Config.pipeline.each { |step| step.call(response) }

      if path =~ /(\.css)|(\.js)\z/
        content = @processor.process_asset(path)

        if !content.nil?
          return stylesheet_response(content, $1)
        end
      end

      @app.call(env)
    end

    private

    def stylesheet_response(stylesheet_content, extension)
      content_type = extension == '.css' ? :css : :javascript

      response = Response.new
      response.set_body stylesheet_content, content_type
      response.set_header 'Cache-Control', 'public, max-age=86400'

      response.build
    end
  end
end
