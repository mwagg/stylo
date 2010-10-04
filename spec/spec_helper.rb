require 'rubygems'
require 'spec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'stylo'
require 'stylo_spec_helpers'

Spec::Runner.configure do |config|
  config.include StyloSpecHelpers
  config.include FileUtils
end


