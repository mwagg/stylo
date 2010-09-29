module Stylo
  class Rack
    def initialize(app)
      @app = app
      @processor = Processor.new
    end

    def call(env)
      path = env["PATH_INFO"]

      if path =~ /\.css\z/
        content = @processor.process_asset(path)

        if !content.nil?
          return stylesheet_response(content)
        end
      end

      @app.call(env)
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