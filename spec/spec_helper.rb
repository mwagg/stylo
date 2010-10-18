require 'rubygems'
require 'rspec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'stylo'
require 'stylo_spec_helpers'

RSpec.configure do |config|
  config.include StyloSpecHelpers
  config.include FileUtils

  config.before(:each) do
    reset_paths
    Stylo::Config.reset_to_default
  end
end


