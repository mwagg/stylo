$LOAD_PATH.unshift(File.dirname(__FILE__))

Dir.glob(File.join(File.dirname(__FILE__), '**/*.rb')).each { |f| require f }


