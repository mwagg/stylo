require 'spec_helper'

describe Stylo::PipelineSteps::Sass do
  let(:step) { Stylo::PipelineSteps::Sass.new }

  describe "when the response has not already been set" do
    describe "and the request is not for a stylesheet" do
      it "should not set the response" do
        response = Stylo::Response.new('javascripts/test.js')
        Stylo::AssetLoader.stub(:load_content).with(response.path).and_return('some-content')

        step.call(response)

        response.has_content?.should be_false
      end
    end

    describe "and the request is for a stylesheet" do
      let(:requested_path) { 'stylesheets/test.css' }
      let(:sass_path) { 'stylesheets/test.scss' }
      let(:response) { Stylo::Response.new(requested_path) }
      let(:base_path) { File.dirname(response.path)  }

      it "should ask the asset loader to load the sass stylesheet content" do
        Stylo::AssetLoader.should_receive(:load_content).with(sass_path).and_return(nil)

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
        let(:combined_stylesheet_content) { "html { color: $red; }" }
        let(:processed_content) { "html { color: red; }" }
        let(:sass_engine) { mock(:sass_engine) }
        let(:combiner) { mock(:combiner) }

        before(:each) do
          Stylo::AssetLoader.stub(:load_content).and_return(stylesheet_content)
          Stylo::Combiner.stub(:new).with('stylesheets', /@import "(.*)";/).and_return(combiner)
          combiner.stub(:process).with(base_path, stylesheet_content).and_return(combined_stylesheet_content)
          ::Sass::Engine.stub(:new).with(combined_stylesheet_content, {:syntax => :scss}).and_return(sass_engine)
          sass_engine.stub(:render).and_return(processed_content)
        end

        it "should tell the combiner to process the stylesheet content" do
          Stylo::Combiner.should_receive(:new).with('stylesheets', /@import "(.*)";/).and_return(combiner)
          combiner.should_receive(:process).with(base_path, stylesheet_content).and_return(combined_stylesheet_content)

          step.call(response)
        end

        it "should run the combined content through sass" do
          ::Sass::Engine.should_receive(:new).with(combined_stylesheet_content, {:syntax => :scss}).and_return(sass_engine)
          sass_engine.should_receive(:render).and_return(processed_content)

          step.call(response)
        end

        it "should set the body of the response to the combined stylesheet content" do
          step.call(response)

          response.body.should == processed_content
        end

        it "should set the content type to text/css" do
          step.call(response)

          response.headers['Content-Type'].should == 'text/css'
        end
      end
    end
  end

  describe "when the response has already been set" do
    it "should not alter the response" do
      response = Stylo::Response.new('stylesheets/test.css')
      response.set_body('some-content', :css)

      step.call(response)

      response.body.should == 'some-content'
    end
  end

end
