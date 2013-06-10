require 'spec_helper'

describe GraphLabel do
  let (:graph_label) { FactoryGirl.create(:graph_label) }
  let (:activity_with_labels) {
    act = FactoryGirl.create(:activity_with_labelset) # 3 labels
    act.pages.first.pick_a_point_sequences.create({:answer_with_label => true, :title => 'Test a label', :initial_prompt => 'Label this!', :give_up => 'Wrong', :confirm_correct => 'Right'}) # 4th label
    act.save
    act
  }

  # Class methods
  describe '#for_activity' do
    it 'returns a flat array of labels belonging to an activity' do
      GraphLabel.for_activity(activity_with_labels).length.should eq(4)
    end

    it 'does not include duplicates' do
      pdgp = FactoryGirl.create(:predefined_graph_pane)
      activity_with_labels.pages[1].predefined_graph_panes << pdgp
      pdgp.graph_labels << GraphLabel.find_by_name("Label for Label this!")
      GraphLabel.for_activity(activity_with_labels).length.should eq(4)
    end
  end

  describe '#free_for_activity' do
    it 'returns a flat array of labels with no label_set belonging to an activity' do
      GraphLabel.free_for_activity(activity_with_labels).length.should eq(1)
    end
  end

  # Instance methods
  describe '#to_hash' do
    context 'with default values' do
      it 'matches the expected hash' do
        expected = { 'x_coord' => graph_label.x_coord, 'y_coord' => graph_label.y_coord, 'text' => graph_label.text }
        graph_label.to_hash.should == expected
        # {
        #   "point": [1,200],
        #   "text": "This is the first point."
        # }
      end
    end

    context 'with interesting values' do
      it 'matches the expected hash' do
        expected = { 'x_coord' => graph_label.x_coord, 'y_coord' => graph_label.y_coord, 'text' => graph_label.text, 'name' => 'George' }
        graph_label.name = 'George'
        graph_label.to_hash.should == expected
        # {
        #   "point": [1,200],
        #   "text": "This is the first point.",
        #   "name": "George"
        # }
      end
    end
  end
end
