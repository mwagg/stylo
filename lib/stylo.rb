$LOAD_PATH.unshift(File.dirname(__FILE__))

Dir.glob(File.join(File.dirname(__FILE__), '**/*.rb')).reject do |filename|
  filename =~ /version.rb$/
end.each { |f| require f }


