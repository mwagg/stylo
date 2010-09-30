module Stylo
  class Rack
    def initialize(app)
      @app = app
      @processor = Processor.new
    end

    def call(env)
      path = env["PATH_INFO"]

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
      content_type = extension == '.css' ? 'text/css' : 'text/javascript'

      [200,
          {
                  'Cache-Control' => 'public, max-age=86400',
                  'Content-Length' => stylesheet_content.length.to_s,
                  'Content-Type' => content_type
          }, stylesheet_content]
    end
  end
end