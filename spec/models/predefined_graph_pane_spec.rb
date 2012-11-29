require 'spec_helper'

describe PredefinedGraphPane do

  describe "validations" do
    # TODO: anything we want to validate in our model?    
  end

  describe "graph_type" do
    its(:graph_type) { should == "PredefinedGraphPane" }
  end
  
  describe "included_datasets" do
    before(:each) do
      dataset_a = mock_model(DataSet, :name => "dataset_a")
      dataset_b = mock_model(DataSet, :name => "dataset_b")
      subject.data_sets << dataset_a
      subject.data_sets << dataset_b
    end
    its(:included_datasets) { should =~ [{"name"=>"dataset_a", "inLegend"=>true}, {"name"=>"dataset_b", "inLegend"=>true}] }
  end

  describe "#to_hash" do
    let(:expected_hash) { 
      {"type"=>"PredefinedGraphPane", "title"=>nil, "yLabel"=>nil, "yMin"=>nil, "yMax"=>nil, "xLabel"=>nil, "xMin"=>nil, "xMax"=>nil, "yTicks"=>nil, "xTicks"=>nil, "showCrossHairs"=>false, "showToolTipCoords"=>false, "showGraphGrid"=>false, "includedDataSets"=>[]} 
    }  
    it "should match our expected hash" do
      subject.to_hash.should == expected_hash
    end

    describe "with some interesting attributes" do
      subject do
        dataset_a = mock_model(DataSet, :name => "dataset_a")
        dataset_b = mock_model(DataSet, :name => "dataset_b")
        PredefinedGraphPane.new({
          :title   => "x in terms of y",
          :y_label => "y",
          :y_min   => 0.0, 
          :y_max   => 1.0, 
          :y_ticks => 0.1, 
          :x_label => "x", 
          :x_min   => 0.0, 
          :x_max   => 10.0,
          :x_ticks => 1.0,
          :data_sets => [dataset_a, dataset_b]
        })
      end

      let(:expected_hash) { 
        {"type"=>"PredefinedGraphPane", "title"=>"x in terms of y", "yLabel"=>"y", "yMin"=>0.0, "yMax"=>1.0, "xLabel"=>"x", "xMin"=>0.0, "xMax"=>10.0, "yTicks"=>0.1, "xTicks"=>1.0, "showCrossHairs"=>false, "showToolTipCoords"=>false, "showGraphGrid"=>false, "includedDataSets"=>[{"name"=>"dataset_a", "inLegend"=>true}, {"name"=>"dataset_b", "inLegend"=>true}]}
      }

      it "should match our expected hash" do
        subject.to_hash.should == expected_hash
      end
    end
  end

 

  describe "included graphs" do
    # TODO: This might be going away sometime:
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
