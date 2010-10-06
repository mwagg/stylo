require 'spec_helper'

describe Stylo::AssetLoader do
  describe "load_content" do
    it "should return nil if the content does not exist" do
      Stylo::AssetLoader.load_content('javascripts/i_dont_exist.js').should be_nil
    end

    it "should return the file content if the content exists" do
      content = "alert('hello');"
      write_content(temp_path('javascripts/i_exist.js'), content)

      Stylo::AssetLoader.load_content('javascripts/i_exist.js').should == content
    end
  end
end