require 'rails'

module Stylo
  class Railtie < Rails::Railtie
    initializer "stylo.initialize" do |app|
      app.middleware.insert_before ActionDispatch::Static, Stylo::Rack
    end
  end
end