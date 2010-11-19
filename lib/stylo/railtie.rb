begin
  require 'rails'

  module Stylo
    class Railtie < Rails::Railtie
      initializer "stylo.initialize" do |app|
        Stylo::Config.options[:asset_location] ||= File.join(app.root, 'public')
        app.middleware.insert_before ActionDispatch::Static, Stylo::Rack
      end
    end
  end
rescue LoadError
end