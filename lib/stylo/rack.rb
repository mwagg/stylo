module Stylo
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      path = env["PATH_INFO"]

      if path =~ /\.css\z/
        processor = Processor.new
        processor.process_template(path)
      else
        @app.call(env)
      end
    end
  end
end