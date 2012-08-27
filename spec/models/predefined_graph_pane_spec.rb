require 'spec_helper'

describe PredefinedGraphPane do
  describe "#normalize_data" do
    it "should run on empty graph" do
      empty_data = ""
      subject.normalize_data
      subject.data.should match empty_data
    end
    it "should return comma separated data" do
      subject.data = "1,2\n1,3"
      subject.normalize_data
      subject.data.should == "1,2\n1,3"
    end
    it "tabs should be replaced by comma separated data" do
      subject.data = "1\t2\n1\t3"
      subject.normalize_data
      subject.data.should == "1,2\n1,3"
    end
    it "extra lines should be stripped" do
      subject.data = "\n\n1,2\n1,3\n\n"
      subject.normalize_data
      subject.data.should == "1,2\n1,3"
    end
    it "extra space should be stripped" do
      subject.data = "1 , 2  \n 1 , 3"
      subject.normalize_data
      subject.data.should == "1,2\n1,3"
    end
  end

  describe "#to_hash" do
    let(:expected_hash) { 
      {"type"=>"PredefinedGraphPane", "title"=>nil, "yLabel"=>nil, "yUnits"=>nil, "yMin"=>nil, "yMax"=>nil, "xLabel"=>nil, "xUnits"=>nil, "xMin"=>nil, "xMax"=>nil, "yTicks"=>nil, "yPrecision"=>0.1, "xTicks"=>nil, "xPrecision"=>0.1, "data"=>[]}
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
      :data => "1,1,2,2,3,3,4,4"
      })}
    
    describe "#to_hash" do
      let(:expected_hash) { 
       {"type"=>"PredefinedGraphPane", "title"=>"x in terms of y", "yLabel"=>"y", "yUnits"=>nil, "yMin"=>0.0, "yMax"=>1.0, "xLabel"=>"x", "xUnits"=>nil, "xMin"=>0.0, "xMax"=>10.0, "yTicks"=>0.1, "yPrecision"=>0.1, "xTicks"=>1.0, "xPrecision"=>0.1, "data"=>[[1.0, 1.0, 2.0, 2.0, 3.0, 3.0, 4.0, 4.0]]}
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
