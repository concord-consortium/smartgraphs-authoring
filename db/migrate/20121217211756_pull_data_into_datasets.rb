class PullDataIntoDatasets < ActiveRecord::Migration
  def self.up
    # Pull data from PredefinedGraphPanes and PredictionGraphPanes into DataSets
    DataSet.convertAllGraphPanes();
    # Link Sequences with datasets
    # - Build array of sequences
    sequences = NumericSequence.all
    sequences << LineConstructionSequence.all
    sequences << MultipleChoiceSequence.all
    sequences << SlopeToolSequence.all
    sequences.each do |seq|
      # Check for predefined graph panes, prediction graph panes, and senor graph panes in that order
      # Use their data set as the sequence data set if one is found.
      if seq.page.predefined_graph_panes.length > 0
        seq.data_set = seq.page.predefined_graph_panes.first.data_sets.first
      elsif seq.page.prediction_graph_panes.length > 0
        seq.data_set = seq.page.prediction_graph_panes.first.data_sets.first
      elsif seq.page.sensor_graph_panes.length > 0
        seq.data_set = seq.page.sensor_graph_panes.first.data_sets.first
      end
      seq.save
    end
  end

  def self.down
  end
end
