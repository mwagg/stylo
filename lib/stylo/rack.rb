module Stylo
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      path = env["PATH_INFO"]

      response = Response.new(path)
      Stylo::Config.pipeline.each { |step| step.call(response) }

      if response.has_content?
        response.build
      else
        @app.call(env)
      end
    end
  end
end
