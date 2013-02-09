require 'spec_helper'

describe Page do
  let(:activity) { create(:activity) }

  describe "that does not belong to an activity" do
    subject() { create(:page, :name => "The First Page") }

    it "#to_hash" do
      subject.to_hash["name"].should == "The First Page"
    end
  end
  describe "that belongs to an activity" do
    subject() { create(:page, :activity => activity, :name => "The First Page")}

    it "#to_hash" do
      subject.to_hash["name"].should == "1 The First Page"
    end

    describe "it's the 13th page in the activity" do
      subject() do
        1..12.times do
          create(:page, :activity => activity, :name => " Page")
        end
        create(:page, :activity => activity, :name => "Final Page")
      end
      it "#to_hash" do
        subject.to_hash["name"].should == "13 Final Page"
      end
      
    end
    describe "and where it's name starts with a digit" do
      subject() { create(:page, :activity => activity, :name => "1 The First Page")}      

      it "#to_hash" do
        subject.to_hash["name"].should == "1 The First Page"
      end
    end

    it "can't be moved to another activity" do
      subject() { create(:page, :activity => activity, :name => "2 The Second Page")}
      act2 = Activity.create(:name => "Target Activity")
      subject.activity_id.should == activity.id
      subject.activity = act2
      subject.save
      subject.reload
      subject.activity_id.should == activity.id
    end
  end
end
