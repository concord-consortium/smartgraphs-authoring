require 'spec_helper'

describe Activity do
  subject { create(:activity)}

  describe "that is private" do
    subject { create(:private_activity)}
    
    it "should be valid" do
      subject.should be_valid
    end

    its(:publication_status) { should == 'private'}
    its(:name) { should == 'Private Activity'}

    it "can be changed to public" do
      subject.publication_status = 'public'
      subject.should be_valid
    end

    it "must be either public or private" do
      subject.publication_status = 'foopublic'
      subject.should_not be_valid      
    end
  end

  describe 'associations' do
    let(:physics) { create(:physics)}
    let(:math) { create(:math)}
    let(:mid) { create(:mid)}
    let(:high) { create(:high)}
    
    its(:pages){ should have(0).pages }
    its(:data_sets){ should have(0).data_sets }

    describe "subject areas" do
      its(:subject_areas){ should have(0).subject_areas }

      it "can belong to many subject areas" do
        subject.subject_areas = [physics, math]
        subject.subject_areas.should have(2).subject_areas
        subject.subject_areas.should include(physics)
        subject.subject_areas.should include(math)
      end
    end
    describe "grade_levels" do
      its(:grade_levels){ should have(0).grade_levels }

      it "can belong to many grade levels" do
        subject.grade_levels = [mid, high]
        subject.grade_levels.should have(2).grade_levels
        subject.grade_levels.should include(mid)
      end
    end
  end

  describe "activity with a data set" do
    let(:activity_with_dataset) { create(:activity_with_dataset) }

    it "should have one data set " do
      activity_with_dataset.data_sets.should have(1).data_sets
            activity_with_dataset.data_sets.first.name.should == "full_data_set"
      activity_with_dataset.data_sets.first.should have(1).predefined_graph_panes
      activity_with_dataset.data_sets.first.should have(1).sensor_graph_panes
      activity_with_dataset.data_sets.first.should have(1).prediction_graph_panes
      
    end

    it "should copy" do
      copy = activity_with_dataset.copy_activity
      activity_with_dataset.to_hash.should == copy.to_hash
      
    end
  end
end
