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

  describe '#included_datasets' do
    it 'returns a hash of dataset names and inLegend values' do
      dataset_hash = [{
        'name' => 'dataset_a',
        'inLegend' => false
      }, {
        'name' => 'dataset_b',
        'inLegend' => false
      }]
      graph_pane.data_sets << [dataset_a, dataset_b]
      graph_pane.included_datasets.should == dataset_hash
    end
  end
end
