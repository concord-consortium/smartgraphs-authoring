require 'spec_helper'

describe LabelSequence do
  let (:label_seq) { FactoryGirl.create(:label_sequence) }

  describe 'default values' do
    it 'gets defaults from the class definition' do
      LabelSequence.defaults.each_pair do |key,value|
        label_seq.send(key).should == value
      end
    end

    it 'gets other defaults from the database' do
      label_seq.title.should == 'New label sequence'
      label_seq.label_count.should == 1
    end
  end

  describe 'validations' do
    it 'requires title to be not-blank' do
      label_seq.should be_valid
      label_seq.title = ''
      label_seq.should_not be_valid
    end

    it 'requires label_count to be a number' do
      label_seq.should be_valid
      label_seq.label_count = 'Two'
      label_seq.should_not be_valid
      label_seq.label_count = 2
      label_seq.should be_valid
    end
  end

  describe '#to_hash' do
    context 'with default values' do
      it 'matches the expected hash' do
        expected = {
          'title' => 'New label sequence',
          'type' => 'LabelSequence',
          'text' => 'Place a label on the graph.',
          'labelSet' => nil,
          'numberOfLabels' => 1
        }
        label_seq.to_hash.should == expected
      end
    end

    context 'with a label_set' do
      it 'matches the expected hash' do
        ls = FactoryGirl.create(:label_set)
        label_seq.label_set = ls
        expected = {
          'type' => 'LabelSequence',
          'title' => 'New label sequence',
          'text' => 'Place a label on the graph.',
          'labelSet' => ls.name,
          'numberOfLabels' => 1
        }
        label_seq.to_hash.should == expected
      end
    end
  end

  describe '#type' do
    it 'is LabelSequence' do
      label_seq.type.should == 'LabelSequence'
    end
  end
end
