require 'rubygems'
require 'spec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'stylo'

module StyloSpecHelpers
  def temp_path(path = '')
    File.expand_path(File.join(File.dirname(__FILE__), '../tmp', path))
  end

  def write_content(path, content)
    File.open(path, 'w') do |f|
      f.write(content)
    end
  end
end

Spec::Runner.configure do |config|
  config.include StyloSpecHelpers
  config.include FileUtils
end


