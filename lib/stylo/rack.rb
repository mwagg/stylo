module Stylo
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      path = env["PATH_INFO"]

      if path =~ /\.css\z/
        processor = Processor.new
        content = processor.process_stylesheet(path)

        stylesheet_response(content)
      else
        @app.call(env)
      end
    end

    private

    def stylesheet_response(stylesheet_content)
      [200,
          {
                  'Cache-Control' => 'public, max-age=86400',
                  'Content-Length' => stylesheet_content.length.to_s,
                  'Content-Type' => 'text/css'
          }, stylesheet_content]
    end
  end
end