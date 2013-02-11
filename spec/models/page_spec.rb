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
  end
end
