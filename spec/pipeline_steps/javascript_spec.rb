require 'spec_helper'

describe Stylo::PipelineSteps::Javascript do
  let(:step) { Stylo::PipelineSteps::Javascript.new }

  describe "when the response has not already been set" do
    describe "and the request is not for a javascript asset" do
      it "should not set the response" do
        response = Stylo::Response.new('stylesheets/test.css')
        Stylo::AssetLoader.stub(:load_content).with(response.path).and_return('some-content')

        step.call(response)

        response.has_content?.should be_false
      end
    end

    describe "and the request is for a javascript asset" do
      let(:response) { Stylo::Response.new('javascripts/test.js') }
      let(:base_path) { File.dirname(response.path)  }

      before(:each) do

      end

      it "should ask the asset loader to load the javascript content" do
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
        let(:javascript_content) { '///require "child.js";' }
        let(:combined_javascript_content) { "alert('hello world');" }
        let(:combiner) { mock(:combiner) }

        before(:each) do
          Stylo::AssetLoader.stub(:load_content).and_return(javascript_content)
          Stylo::Combiner.stub(:new).with(/\/\/\/require "(.*)";/).and_return(combiner)
          combiner.stub(:process).with(base_path, javascript_content).and_return(combined_javascript_content)
        end

        describe "and combining is enabled" do
          before(:each) do
            Stylo::Config.javascript_combining_enabled = true
          end

          it "should tell the combiner to process the javascript content" do
            Stylo::Combiner.should_receive(:new).with(/\/\/\/require "(.*)";/).and_return(combiner)
            combiner.should_receive(:process).with(base_path, javascript_content).and_return(combined_javascript_content)

            step.call(response)
          end

          it "should set the body of the response to the combined javascript content" do
            step.call(response)

            response.body.should == combined_javascript_content
          end
        end

        describe "and combining is disabled" do
          before(:each) do
            Stylo::Config.javascript_combining_enabled = false
          end

          it "should set the body of the response to the javascript content" do
            step.call(response)

            response.body.should == javascript_content
          end
        end

        it "should set the content type to text/javascript" do
          step.call(response)

          response.headers['Content-Type'].should == 'text/javascript'
        end
      end
    end
  end

  describe "when the response has already been set" do
    it "should not alter the response" do
      response = Stylo::Response.new('javascripts/test.js')
      response.set_body('some-content', :css)

      step.call(response)

      response.body.should == 'some-content'
    end
  end
end
