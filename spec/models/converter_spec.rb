require 'spec_helper'

describe Converter do
  before(:each) do
    @converter = Converter.new() # will create converter to /bin/cat
  end
  
  describe "convert with cat" do
    it "should return the same output as input" do
      sent = "testing testing 1 2 3"
      expected = sent
      @converter.convert(sent).should == expected
    end
  end

end

