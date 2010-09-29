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
    describe "and the stylesheet can be processed" do
      before(:each) do
        env['PATH_INFO'] = 'stylesheets/style.css'
        @processor_response = 'this is the response from the processor'
        processor.stub(:process_asset).and_return(@processor_response)
      end

      it "should ask the processor to process the path" do
        processor.should_receive(:process_asset).with('stylesheets/style.css')
        rack.call(env)
      end

      it "should not pass the call back to the app" do
        app.should_not_receive(:call)
        rack.call(env)
      end

      it "should return a 200 OK response" do
        response = rack.call(env)
        status_code(response).should == 200
      end

      it "should set the content type to text/css" do
        response = rack.call(env)
        content_type(response).should == 'text/css'
      end

      it "should set the content length to the length of the processed stylesheet" do
        response = rack.call(env)
        content_length(response).should == @processor_response.length.to_s
      end

      it "should set the content to be cached for 1 day" do
        response = rack.call(env)
        cache_control(response).should == "public, max-age=86400"
      end

      it "should set the content to be the processed stylesheet" do
        response = rack.call(env)
        content(response).should == @processor_response
      end
    end

    describe "and the stylesheet cannot be processed" do
      it "should pass the call back to the app" do
        env['PATH_INFO'] = 'stylesheets/style.css'
        processor.stub(:process_asset).and_return(nil)
        app.should_receive(:call).with(env)

        rack.call(env)
      end
    end
  end

  describe "when requesting something other than a stylesheet" do
    it "should not ask the processor to process the request" do
      app.stub(:call)
      processor.should_not_receive(:process_asset)

      env['PATH_INFO'] = 'javascripts/foo.js'
      rack.call(env)
    end

    it "should pass the call back to the app" do
      app.should_receive(:call).with(env)

      rack.call(env)
    end
  end
end

def status_code(response)
  response[0]
end

def content_type(response)
  response[1]['Content-Type']
end

def content_length(response)
  response[1]['Content-Length']
end

def cache_control(response)
  response[1]['Cache-Control']
end

def content(response)
  response[2]
end