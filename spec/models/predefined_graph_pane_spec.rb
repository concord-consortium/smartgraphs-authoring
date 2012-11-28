require 'spec_helper'

describe PredefinedGraphPane do

  describe "#to_hash" do
    let(:expected_hash) { 
      {"type"=>"PredefinedGraphPane", "title"=>nil, "yLabel"=>nil, "yMin"=>nil, "yMax"=>nil, "xLabel"=>nil, "xMin"=>nil, "xMax"=>nil, "yTicks"=>nil, "xTicks"=>nil, "showCrossHairs"=>false, "showToolTipCoords"=>false, "showGraphGrid"=>false, "includedDataSets"=>[]} 
    }  
    it "should match our expected hash" do
      subject.to_hash.should == expected_hash
    end
  end


 describe "with some interesting attributes" do
    subject { PredefinedGraphPane.create({
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
      :expression => "22 * x - 3",
      :data => "1,1,2,2,3,3,4,4"
      })}

    
    describe "#to_hash" do
      let(:expected_hash) { 
        {"type"=>"PredefinedGraphPane", "title"=>"x in terms of y", "yLabel"=>"y", "yMin"=>0.0, "yMax"=>1.0, "xLabel"=>"x", "xMin"=>0.0, "xMax"=>10.0, "yTicks"=>0.1, "xTicks"=>1.0, "showCrossHairs"=>false, "showToolTipCoords"=>false, "showGraphGrid"=>false, "includedDataSets"=>[]}
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
   
  describe "validations" do
    
  end
end
