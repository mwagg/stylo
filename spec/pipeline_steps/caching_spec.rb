require 'spec_helper'

describe Stylo::PipelineSteps::Caching do
  describe "call" do
    describe "when no response has been set" do
      it "should not add a cache header" do
        response = Stylo::Response.new('stylesheets/test.css')

        Stylo::PipelineSteps::Caching.new().call(response)

        response.headers.should be_empty
      end
    end

    describe "when a response has been set" do
      it "should add a cache header" do
        response = Stylo::Response.new('stylesheets/test.css')
        response.set_body('alert ("hello");', :javascript)

        Stylo::PipelineSteps::Caching.new().call(response)

        response.headers['Cache-Control'].should == 'public, max-age=86400'
      end
    end
  end
end