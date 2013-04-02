require 'spec_helper'

describe Unit do
  let (:unit) { FactoryGirl.create(:unit) }

  describe '#to_hash' do
    it 'matches the expected hash' do
      expected = { 'type' => 'Unit', 'name' => unit.name, 'abbreviation' => unit.abbreviation }
      unit.to_hash.should == expected
    end
  end
end
