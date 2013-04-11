require 'spec_helper'

describe GraphLabel do
  let (:graph_label) { FactoryGirl.create(:graph_label) }

  describe '#to_hash' do
    it 'matches the expected hash' do
      expected = { 'point' => [graph_label.x_coord, graph_label.y_coord], 'text' => graph_label.text }
      graph_label.to_hash.should == expected
      # {
      #   "point": [1,200],
      #   "text": "This is the first point."
      # }
    end
  end
end
