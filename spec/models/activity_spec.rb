require 'spec_helper'

describe Activity do
  describe "publication_status" do
    it "should have a publication status" do
      should.respond_to? :publication_status
    end
    
    it "should use the default value of private" do
      subject.publication_status.should eql 'private'
    end
    
    it "should allow 'public' as a value" do
      subject.publication_status = 'public'
      subject.should be_valid
    end

    it "shouldn't allow 'foo' as a value" do
      subject.publication_status = 'foo'
      subject.should_not be_valid
    end

  end
end
