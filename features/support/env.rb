require 'rack/test'
require 'sinatra'

require File.join(File.dirname(__FILE__), '../../spec/spec_helper')

World do
  include Rack::Test::Methods
  include StyloSpecHelpers
  include FileUtils

  def app
    @app ||= Rack::Builder.new do
      use Stylo::Rack
      run Proc.new {|env| [200, {"Content-Type" => "text/html"}, "Hello World!"]}
    end
  end

  true
end

Before do
  Stylo::Config.reset_to_default
  reset_paths
end

