require 'spec_helper'

describe Stylo::PipelineSteps::StylesheetMinifying do
  before(:each) do
    Stylo::Config.options[:css_minifying_enabled] = true
  end

  let(:step) { Stylo::PipelineSteps::StylesheetMinifying.new }

  describe "when the response body is not a stylesheet" do
    it "should not modify the response body" do
      response = Stylo::Response.new('javascripts/test.js')
      original_body = "alert('hello');"
      response.set_body(original_body, :javascript)

      step.call(response)

      response.body.should == original_body
    end
  end

  describe "when the response body is a stylesheet" do
    let(:response) { Stylo::Response.new('stylesheets/test.css') }
    let(:minified_stylesheet) { 'I am minified!' }

    before(:each) do
      response.set_body('some stylesheet', :css)

      Stylo::CssMinifier.stub(:minify).and_return(minified_stylesheet)
    end

    it "should ask the css minifier to minify the stylesheet" do
      Stylo::CssMinifier.should_receive(:minify).with(response.body)

      step.call(response)
    end

    it "should replace the response body with the minified text" do
      step.call(response)

      response.body.should == minified_stylesheet
    end
  end
end
