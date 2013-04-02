require 'spec_helper'

describe LabelSet do
  let (:activity) { FactoryGirl.create(:activity_with_labelset) }
  let (:label_set) { FactoryGirl.create(:label_set) }
  let (:full_label_set) { FactoryGirl.create(:full_label_set) }

  describe 'validations' do
    it 'enforces unique names within activities' do
      ls2 = FactoryGirl.create(:label_set)
      ls2.name = label_set.name
      ls2.should_not be_valid
      ls2.activity = activity
      # Now there is a different scope so the identical names are OK
      ls2.should be_valid
    end
  end

  describe '#sg_parent' do
    it 'returns the parent activity' do
      ls = activity.label_sets.first
      ls.sg_parent.should == activity
    end
  end

  describe '#field_order' do
    it 'should return the expected field order' do
      label_set.field_order.should == 'name'
    end
  end

  describe '#to_hash' do
    it 'should return the expected hash' do
      expected = { 'name' => full_label_set.name, 'labels' => full_label_set.labels.map { |l| l.to_hash } }
      full_label_set.to_hash.should == expected
    end
  end
end
