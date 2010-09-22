require 'spec_helper'

describe Stylo::Processor do
  before(:each) do
    reset_stylesheet_paths

    @processor = Stylo::Processor.new
  end

  describe "when processing a stylesheet" do
    describe "and the stylesheet exists" do
      before(:each) do
        @stylesheet_content = %Q{html {
          background: #000000;
        }}
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

  describe "when the stylesheet imports another stylesheet" do
    before(:each) do
      @stylesheet_content = %Q{@import "child.css";

      #parent {
        background: #ffffff;
      }}
      write_content(File.join(@stylesheets_path, 'test.css'), @stylesheet_content)
    end

    describe "and the imported stylesheet exists" do
      before(:each) do
        @child_stylesheet_content = %Q{#child {
          background: #000000;
        }}
        write_content(File.join(@stylesheets_path, 'child.css'), @child_stylesheet_content)
      end

      it "should include the contents of the references stylesheet in the processed stylesheet" do
        result = @processor.process_stylesheet('stylesheets/test.css')

        result.should == %Q{#child {
          background: #000000;
        }

      #parent {
        background: #ffffff;
      }}
      end

      describe "and the imported stylesheet itself imports another stylesheet" do
        before(:each) do
          @child_stylesheet_content = %Q{@import "grandchild.css";

          #child {
            background: #000000;
          }}
          write_content(File.join(@stylesheets_path, 'child.css'), @child_stylesheet_content)

          @grandchild_stylesheet_content = %Q{#grandchild {
            background: #000000;
          }}
          write_content(File.join(@stylesheets_path, 'grandchild.css'), @grandchild_stylesheet_content)
        end

        it "should import all the stylesheets into the processed stylesheet" do
          result = @processor.process_stylesheet('stylesheets/test.css')

            result.should == %Q{#grandchild {
            background: #000000;
          }

          #child {
            background: #000000;
          }

      #parent {
        background: #ffffff;
      }}
        end
      end
    end

    describe "and the imported stylesheet does not exist" do
      it "should not replace the @import statement" do
        result = @processor.process_stylesheet('stylesheets/test.css')

        result.should == @stylesheet_content
      end
    end
  end
end
