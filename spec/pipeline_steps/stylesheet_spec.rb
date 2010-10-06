require 'spec_helper'

describe Stylo::PipelineSteps::Stylesheet do
  let(:step) { Stylo::PipelineSteps::Stylesheet.new }

  describe "when the response has not already been set" do
    describe "and the request is not for a stylesheet" do
      it "should not set the response" do
        response = Stylo::Response.new('javascripts/test.js')

        step.call(response)

        response.has_content?.should be_false
      end
    end

    describe "and the request is for a stylesheet" do
      let(:response) { Stylo::Response.new('stylesheets/test.css') }

      before(:each) do

      end

      it "should ask the asset loader to load the stylesheet content" do
        Stylo::AssetLoader.should_receive(:load_content).with(response.path).and_return(nil)

        step.call(response)
      end

      describe "and the asset does not exist" do
        it "should not set the response" do
          Stylo::AssetLoader.stub(:load_content).and_return(nil)

          step.call(response)

          response.has_content?.should be_false
        end
      end

      describe "and the asset exists" do
        let(:stylesheet_content) { "html { color: $color; }" }
        let(:combined_stylesheet_content) { "html { color: red; }" }
        let(:combiner) { mock(:combiner) }

        before(:each) do
          Stylo::AssetLoader.stub(:load_content).and_return(stylesheet_content)
          Stylo::Combiner.stub(:new).with('stylesheets', /@import "(.*)";/).and_return(combiner)
          combiner.stub(:process).with(stylesheet_content).and_return(combined_stylesheet_content)
        end

        it "should tell the combiner to process the stylesheet content" do
          Stylo::Combiner.should_receive(:new).with('stylesheets', /@import "(.*)";/).and_return(combiner)
          combiner.should_receive(:process).with(stylesheet_content).and_return(combined_stylesheet_content)

          step.call(response)
        end

        it "should set the body of the response to the combined stylesheet content" do
          step.call(response)

          response.body.should == combined_stylesheet_content
        end

        it "should set the content type to text/css" do
          step.call(response)

          response.headers['Content-Type'].should == 'text/css'
        end
      end
    end
  end
end