require 'spec_helper'

describe Stylo::Processor do
  before(:each) do
    reset_paths

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
        result = @processor.process_asset('stylesheets/test.css')

        result.should == @stylesheet_content
      end
    end

    describe "and the stylesheet does not exist" do
      it "should return nil" do
        result = @processor.process_asset('stylesheets/test.css')

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
        result = @processor.process_asset('stylesheets/test.css')

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
          result = @processor.process_asset('stylesheets/test.css')

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
      it "should raise an error" do
        proc { result = @processor.process_asset('stylesheets/test.css') }.should raise_error "Cannot find file to import 'child.css'."
      end
    end
  end

  describe "when the javascript imports another javascript file" do
    before(:each) do
      @javascript_content = %Q{///include "child.js";

      function parent() {
        alert('parent');
      }}
      write_content(File.join(@javascripts_path, 'test.js'), @javascript_content)
    end

    describe "and the imported javascript file exists" do
      before(:each) do
        @child_javascript_content = %Q{function child() {
          alert('child');
        }}
        write_content(File.join(@javascripts_path, 'child.js'), @child_javascript_content)
      end

      it "should include the contents of the referenced javascript file in the processed javascript" do
        result = @processor.process_asset('javascripts/test.js')

        result.should == %Q{function child() {
          alert('child');
        }

      function parent() {
        alert('parent');
      }}
      end
    end

    describe "and the imported javascript file does not exist" do
      it "should raise an error" do
        proc { result = @processor.process_asset('javascripts/test.js') }.should raise_error "Cannot find file to import 'child.js'."
      end
    end
  end

  describe "when processing a javascript file" do
    describe "and the javascript file exists" do
      before(:each) do
        @javascript_content = "function sayHello() { alert('hello');}"
        write_content(File.join(@javascripts_path, 'test.js'), @javascript_content)
      end

      it "should return the contents of the javascript file" do
        result = @processor.process_asset('javascripts/test.js')

        result.should == @javascript_content
      end
    end

    describe "and the javascript file does not exist" do
      it "should return nil" do
        result = @processor.process_asset('javascripts/test.js')

        result.should be_nil
      end
    end
  end
end
