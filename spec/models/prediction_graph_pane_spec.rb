require 'spec_helper'

describe PredictionGraphPane do

  # TODO: make some tests for these methods:
  describe "#get_indexed_path"
  describe "self.get_all_graph_panes_before"
  describe "self.get_all_prediction_graph_panes_before"
  describe "self.is_graph_pane?"

  describe "zero argument constructor defaults" do
    describe "#to_hash" do
      let(:expected_hash) { 
        { "type"=>"PredictionGraphPane", "title"=>nil, "yLabel"=>nil, "yMin"=>nil, "yMax"=>nil, "xLabel"=>nil, "xMin"=>nil, "xMax"=>nil, "yTicks"=>nil, "xTicks"=>nil, "xPrecision"=>0.1, "yPrecision"=>0.1, "predictionType"=>nil, "showGraphGrid"=>false, "showCrossHairs"=>false, "showToolTipCoords"=>false, "includedDataSets"=>[] }
      }
      it "should match our expected hash" do
        subject.to_hash.should == expected_hash
      end
    end
  end

 describe "with some interesting attributes" do
    subject { PredictionGraphPane.create({
      :title   => "x in terms of y",
      :y_label => "y",
      :y_min   => 0.0, 
      :y_max   => 1.0, 
      :y_ticks => 0.1, 
      :x_label => "x", 
      :x_min   => 0.0, 
      :x_max   => 10.0,
      :x_ticks => 1.0,
      :x_precision => 0.1,
      :show_graph_grid => true,
      :show_cross_hairs => true,
      :show_tool_tip_coords => true,
      :prediction_type => 'connecting_points'
    })}
    
    describe "#to_hash" do
      let(:expected_hash) { 
       {"type"=>"PredictionGraphPane", "title"=>"x in terms of y", "yLabel"=>"y", "yMin"=>0.0, "yMax"=>1.0, "xLabel"=>"x", "xMin"=>0.0, "xMax"=>10.0, "yTicks"=>0.1, "xTicks"=>1.0, "xPrecision"=>0.1, "yPrecision"=>0.1, "predictionType"=>"connecting_points", "showGraphGrid"=>true, "showCrossHairs"=>true, "showToolTipCoords"=>true, "includedDataSets"=>[]} 
      }  
      it "should match our expected hash" do
        subject.to_hash.should == expected_hash
      end
    end
  end
    
  describe "included graphs" do
    before(:each) do
      @included_graph = double('PredefinedGraphPane')
      @included_graph.stub(:get_indexed_path => "fake/path/here")
      @test_subject = subject
      @test_subject.stub(:included_graphs => [@included_graph])
    end

    it "should match our expected hash" do
      @test_subject.to_hash.should include({"includeAnnotationsFrom"=>["fake/path/here"]})
    end
  end
  
end
