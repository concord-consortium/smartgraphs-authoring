class PullDataIntoDatasets < ActiveRecord::Migration
  def self.up
    # Pull data from PredefinedGraphPanes and PredictionGraphPanes into DataSets
    DataSet.convertAllGraphPanes();
    # Link Sequences with datasets
    [NumericSequence, LineConstructionSequence, MultipleChoiceSequence, PickAPointSequence, SlopeToolSequence].each { |m| m.reset_column_information }
    # - Build array of sequences
    sequences = []
    sequences << NumericSequence.all
    sequences << LineConstructionSequence.all
    sequences << MultipleChoiceSequence.all
    sequences << PickAPointSequence.all
    sequences << SlopeToolSequence.all
    sequences.flatten.each do |seq|
      # Check for predefined graph panes, prediction graph panes, and senor graph panes in that order
      # Use their data set as the sequence data set if one is found.
      if seq.page
        if seq.page.activity
          if seq.page.predefined_graph_panes.length > 0
            seq.data_set = seq.page.predefined_graph_panes.first.data_sets.first
          elsif seq.page.prediction_graph_panes.length > 0
            seq.data_set = seq.page.prediction_graph_panes.first.data_sets.first
          elsif seq.page.sensor_graph_panes.length > 0
            seq.data_set = seq.page.sensor_graph_panes.first.data_sets.first
          end
          say "#{seq.class.to_s} #{seq.id} is getting data_set #{seq.data_set ? seq.data_set.name : 'nil'}"
          say "(from Activity #{seq.data_set.activity.id})" unless seq.data_set.nil?
          seq.save
        else
          say "#{seq.class.to_s} #{seq.id} belongs to a page with no activity."
        end
      else
        say "#{seq.class.to_s} #{seq.id} has no associated page."
      end
    end
  end

  def self.down
  end
end
