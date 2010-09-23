require 'spec_helper'

describe Stylo::Sass do
  before(:each) do
    reset_stylesheet_paths

    Stylo::Config.enable_sass = true
    @processor = Stylo::Processor.new
  end

  describe "get_file_content" do
    describe "when the requested file does not exist as an scss file" do
      before(:each) do
        @stylesheet_content = %Q{html {
          background: #000000;
        }}
        write_content(File.join(@stylesheets_path, 'test.css'), @stylesheet_content)
      end

      it "should follow the default behaviour" do
        result = @processor.get_file_content(temp_path('stylesheets/test.css'))

        result.should == @stylesheet_content
      end
    end

    describe "when the requested file exists as an scss file" do
      before(:each) do
        @stylesheet_content = %Q{html {
          background: #000000;
        }}
        write_content(File.join(@stylesheets_path, 'test.scss'), @stylesheet_content)
      end

      it "should return the contents of the scss file" do
        result = @processor.get_file_content(temp_path('stylesheets/test.css'))

        result.should == @stylesheet_content
      end
    end
  end

  describe "process_stylesheet" do
    it "should process the stylesheet using sass" do
      @stylesheet_content = "$some_color: #00FF00;\nhtml {\n  background: $some_color; }"

      write_content(File.join(@stylesheets_path, 'test.css'), @stylesheet_content)

      result = @processor.process_stylesheet('stylesheets/test.css')

      result.should == "html {\n  background: lime; }\n"
    end
  end
end
