require 'spec_helper'

describe PredefinedGraphPane do
  let (:graph_pane) { FactoryGirl.create(:predefined_graph_pane) }
  let (:dataset_a) { FactoryGirl.create(:data_set, :name => "dataset_a") }
  let (:dataset_b) { FactoryGirl.create(:data_set, :name => "dataset_b") }

  describe "validations" do
    # TODO: anything we want to validate in our model?    
  end

  describe "graph_type" do
    it 'returns a string describing the class name' do
      graph_pane.graph_type.should == "PredefinedGraphPane"
    end
  end
  
  describe "included_datasets" do
    it 'includes data_sets' do
      graph_pane.data_sets << dataset_a
      graph_pane.data_sets << dataset_b
      graph_pane.save
      graph_pane.included_datasets.should =~ [{"name"=>"dataset_a", "inLegend"=>false}, {"name"=>"dataset_b", "inLegend"=>false}]
    end
  end

  describe "#to_hash" do
    let(:expected_hash) { 
      {"type"=>"PredefinedGraphPane", "title"=>'predefined_graph_pane_3', "yLabel"=>'y label', "yMin"=>0.0, "yMax"=>10.0, "xLabel"=>'x label', "xMin"=>0.0, "xMax"=>10.0, "yTicks"=>10.0, "xTicks"=>10.0, "showCrossHairs"=>false, "showToolTipCoords"=>false, "showGraphGrid"=>false, "includedDataSets"=>[]} 
    }  
    it "should match our expected hash" do
      expected_hash['title'] = graph_pane.title
      graph_pane.to_hash.should == expected_hash
    end

    describe "with some interesting attributes" do
      let(:expected_hash) { 
        {"type"=>"PredefinedGraphPane", "title"=>"predefined_graph_pane_4", "yLabel"=>"y label", "yMin"=>0.0, "yMax"=>10.0, "xLabel"=>"x label", "xMin"=>0.0, "xMax"=>10.0, "yTicks"=>10.0, "xTicks"=>10.0, "showCrossHairs"=>false, "showToolTipCoords"=>false, "showGraphGrid"=>false, "includedDataSets"=>[{"name"=>"dataset_a", "inLegend"=>false}, {"name"=>"dataset_b", "inLegend"=>false}]}
      }

      it "should match our expected hash" do
        expected_hash['title'] = graph_pane.title
        graph_pane.data_sets << dataset_a
        graph_pane.data_sets << dataset_b
        graph_pane.save
        graph_pane.to_hash.should == expected_hash
      end

      it "should allow datasets to appear in legend" do
        pending 'This is working in console but not in rspec.'
        graph_pane.data_sets << dataset_a
        graph_pane.data_sets << dataset_b
        graph_pane.data_set_predefined_graphs.first.in_legend = true

        graph_pane.to_hash.should include("includedDataSets" => [{"name"=>"dataset_a", "inLegend"=>true}, {"name"=>"dataset_b", "inLegend"=>false}])
      end

      it 'should allow labelsets' do
        graph_pane.label_sets << FactoryGirl.create(:label_set)
        graph_pane.to_hash.should include('labelSetNames')
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
