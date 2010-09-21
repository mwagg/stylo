require 'spec_helper'

describe Stylo::Processor do
  before(:each) do
    @stylesheets_path = temp_path('stylesheets')
    rm_rf @stylesheets_path
    mkdir_p @stylesheets_path

    Stylo::Config.public_location = temp_path()
    @processor = Stylo::Processor.new
  end

  describe "when processing a stylesheet" do
    describe "and the stylesheet exists" do
      before(:each) do
        @stylesheet_content = %Q{
          html {
            background: #000000;
          }
        }
        write_content(File.join(@stylesheets_path, 'test.css'), @stylesheet_content)
      end

      it "should return the contents of the stylesheet" do
        result = @processor.process_stylesheet('stylesheets/test.css')

        result.should == @stylesheet_content
      end
    end

    describe "and the stylesheet does not exist" do
      it "should return nil" do
        result = @processor.process_stylesheet('stylesheets/test.css')

        result.should be_nil
      end
    end
  end
end
