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


  describe "associations" do
    before(:all) do
      # mock these instead?
      @physics = SubjectArea.create(:name => "pysics")
      @math    = SubjectArea.create(:name => "math")
      @mid     = GradeLevel.create(:name  => "6-9")
      @high    = GradeLevel.create(:name  => "10-12")
      subject.name = "testing"
    end

    describe "subect_areas" do
      it "should have no subject areas by default" do
        subject.subject_areas.should be_empty
      end

      it "can belong to multiple subject areas" do
        subject.subject_areas = [@physics,@math]
        subject.subject_areas.should include(@math)
        subject.subject_areas.should include(@physics)
      end
    end

    describe "grade_levels" do
      it "should be empty by default" do
        subject.grade_levels.should be_empty
      end

      it "can belong to multiple subject areas" do
        subject.grade_levels = [@mid,@high]
        subject.grade_levels.should include(@mid)
        subject.grade_levels.should include(@high)
      end
    end
  end

end
