require 'rack/test'
require 'sinatra'

require File.join(File.dirname(__FILE__), '../../spec/spec_helper')

class MyApp < Sinatra::Application

end

World do
  include Rack::Test::Methods
  include StyloSpecHelpers
  include FileUtils

  def app
    @app ||= Rack::Builder.new do
      use Stylo::Rack
      run MyApp
    end
  end

  reset_paths
end

Before do
  Stylo::Config.reset_to_default
end

