require 'spec_helper'

describe Stylo::Rack do
  let(:app) { mock(:app) }
  let(:env) { {} }

  describe "call" do
    let(:pipeline_steps) { [] }

    before(:each) do
      app.stub(:call)

      Stylo::Config.stub(:pipeline).and_return(pipeline_steps)
    end

    it "should call each pipeline step" do
      3.times do |i|
        step = mock("pipeline step #{i}")
        step.should_receive(:call).with(instance_of(Stylo::Response))
        pipeline_steps << step
      end

      Stylo::Rack.new(app).call(env)
    end

    describe "when no step has been able to deal with the request" do
      it "should call back into the app" do
        app.should_receive(:call).with(env)

        Stylo::Rack.new(app).call(env)
      end
    end

    describe "when a step has been able to deal with the request" do
      let(:response) { mock(:response, :has_content? => true) }

      before(:each) do
        Stylo::Response.stub(:new).and_return(response)
      end

      it "should not call back into the app" do
        app.should_not_receive(:call).with(env)
        response.stub(:build)

        Stylo::Rack.new(app).call(env)
      end

      it "should return the built response" do
        response.stub(:build).and_return([200, {}, "some-content"])

        Stylo::Rack.new(app).call(env).should == response.build
      end
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