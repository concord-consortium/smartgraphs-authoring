require 'spec_helper'

describe SensorGraphPane do
  describe "zero argument constructor defaults" do
    describe "#to_hash" do
      let(:expected_hash) { 
        {"type"=>"SensorGraphPane", "title"=>nil, "yLabel"=>nil, "yUnits"=>nil, "yMin"=>nil, "yMax"=>nil, "xLabel"=>nil, "xUnits"=>nil, "xMin"=>nil, "xMax"=>nil, "yTicks"=>nil, "xTicks"=>nil }
      }  
      it "should match our expected hash" do
        subject.to_hash.should == expected_hash
      end
    end
  end

  describe "with some interesting attributes" do
    subject { SensorGraphPane.create({
      :title   => "x in terms of y",
      :y_label => "y",
      :y_min   => 0.0, 
      :y_max   => 1.0, 
      :y_ticks => 0.1, 
      :x_label => "x", 
      :x_min   => 0.0, 
      :x_max   => 10.0,
      :x_ticks => 1.0, 
      })}

    describe "#to_hash" do
      let(:expected_hash) { 
       {"type"=>"SensorGraphPane", "title"=>"x in terms of y", "yLabel"=>"y", "yUnits"=>nil, "yMin"=>0.0, "yMax"=>1.0, "xLabel"=>"x", "xUnits"=>nil, "xMin"=>0.0, "xMax"=>10.0, "yTicks"=>0.1, "xTicks"=>1.0}
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
