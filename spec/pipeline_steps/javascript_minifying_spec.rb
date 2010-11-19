require 'spec_helper'

describe Stylo::PipelineSteps::JavascriptMinifying do
  before(:each) do
    Stylo::Config.options[:javascript_minifying_enabled] = true
  end

  let(:step) { Stylo::PipelineSteps::JavascriptMinifying.new }
  let(:jsmin) { mock(:jsmin) }

  describe "when the response body is not javascript" do
    it "should not modify the response body" do
      response = Stylo::Response.new('stylesheets/test.css')
      original_body = "html{ color:#000; }"
      response.set_body(original_body, :css)

      step.call(response)

      response.body.should == original_body
    end
  end

  describe "when the response body is javascript" do
    let(:response) { Stylo::Response.new('javascrips/test.js') }
    let(:minified_javascript) { 'I am minified!' }

    before(:each) do
      response.set_body('some javascript', :javascript)

      JSMin.stub(:new).with(response.body).and_return(jsmin)
      jsmin.stub(:minify).and_return(minified_javascript)
    end

    it "should ask jsmin to minify the javascript" do
      JSMin.should_receive(:new).with(response.body).and_return(jsmin)
      jsmin.should_receive(:minify)

      step.call(response)
    end

    it "should replace the response body with the minified text" do
      step.call(response)

      response.body.should == minified_javascript
    end
  end
end
