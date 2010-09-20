require 'spec_helper'

describe Stylo::Rack do
  let(:app) { mock(:app) }
  let(:processor) { mock(:processor) }
  let(:rack) { Stylo::Rack.new(app) }
  let(:env) { {} }

  before(:each) do
    Stylo::Processor.stub(:new).and_return(processor)
  end

  describe "when requesting a stylesheet" do
    before(:each) do
      env['PATH_INFO'] = 'stylesheets/style.css'
      processor.stub(:process_template)
    end

    it "should ask the processor to process the path" do
      processor.should_receive(:process_template).with('stylesheets/style.css').and_return(true)
      rack.call(env)
    end

    it "should not pass the call back to the app" do
      app.should_not_receive(:call)
      rack.call(env)
    end
  end

  describe "when requesting something other than a stylesheet" do
    it "should not ask the processor to process the request" do
      app.stub(:call)
      processor.should_not_receive(:process_template)

      env['PATH_INFO'] = 'javascripts/foo.js'
      rack.call(env)
    end

    it "should pass the call back to the app" do
      app.should_receive(:call).with(env)

      rack.call(env)
    end
  end
end