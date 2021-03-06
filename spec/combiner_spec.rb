require 'spec_helper'

describe Stylo::Combiner do
  let(:request_path_directory) { 'assets' }
  let(:combiner) { Stylo::Combiner.new(/require "(.*)";/) }

  describe "when the content does not contain the require pattern" do
    let(:content) { "This is some text." }

    it "should return the content" do
      combiner.process(request_path_directory, content).should == content
    end
  end

  describe "when the content contains the require pattern" do
    let(:content) { 'require "some_other_file"; and then some other content' }

    before(:each) do
      Stylo::AssetLoader.stub(:load_content).with('assets/some_other_file').and_return('the required content.')
    end

    it "should load required content from the asset loader" do
      Stylo::AssetLoader.should_receive(:load_content).with('assets/some_other_file').and_return('the required content.')

      combiner.process(request_path_directory, content)
    end

    describe "when the required content exists" do
      before(:each) do
	Stylo::AssetLoader.stub(:load_content).with('assets/some_other_file').and_return('the required content.')
      end

      it "should return the required content" do
	combiner.process(request_path_directory, content).should == 'the required content. and then some other content'
      end

      describe "and the required content has the require pattern" do
        it "should combine the content recursively" do
          Stylo::AssetLoader.stub(:load_content).with('assets/some_other_file').and_return('require "yet_another_file"; the required content.')
          Stylo::AssetLoader.stub(:load_content).with('assets/yet_another_file').and_return('the other required content.')

          combiner.process(request_path_directory, content).should == "the other required content. the required content. and then some other content"
        end
      end
    end

    describe "when the required content does not exist" do
      before(:each) do
	Stylo::AssetLoader.stub(:load_content).with('assets/some_other_file').and_return(nil)
      end

      it "should raise an error" do
        proc { combiner.process(request_path_directory, content) }.should raise_error("Cannot find referenced asset 'some_other_file'.")
      end
    end
  end
end
