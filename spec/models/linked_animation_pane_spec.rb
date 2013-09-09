require 'spec_helper'

describe LinkedAnimationPane do
  let (:graph_pane) { FactoryGirl.create(:linked_animation_pane) }
  let (:dataset_a) { FactoryGirl.create(:data_set, :name => "dataset_a") }
  let (:dataset_b) { FactoryGirl.create(:data_set, :name => "dataset_b") }

  describe '#graph_type' do
    it 'returns a string describing the type of the graph pane' do
      graph_pane.graph_type.should == 'LinkedAnimationPane'
    end
  end
end
