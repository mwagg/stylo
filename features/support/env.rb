require 'fileutils'
require 'rack'
require 'rack/test'
require 'sinatra'
require File.join(File.dirname(__FILE__), '../../lib/stylo')
require File.join(File.dirname(__FILE__), '../../spec/stylo_spec_helpers')

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

