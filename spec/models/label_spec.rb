require 'spec_helper'

describe Label do
  let (:label) { FactoryGirl.create(:label) }

  describe '#to_hash' do
    it 'matches the expected hash' do
      expected = { 'point' => [label.x_coord, label.y_coord], 'text' => label.text }
      label.to_hash.should == expected
      # {
      #   "point": [1,200],
      #   "text": "This is the first point."
      # }
    end
  end

  describe '#field_order' do
    it 'returns a string with visible/editable fields' do
      label.field_order.should == 'text, x_coord, y_coord'
    end
  end
end
