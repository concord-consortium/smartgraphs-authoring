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

  describe "#normalize_expression" do
    it "should get rid of the left side of y =" do
      subject.expression="y = 23 * x + 4"
      subject.normalize_expression
      subject.expression.should == "23 * x + 4"
    end
    it "should leave well enough alone" do
      subject.expression="22 * x + 6"
      subject.normalize_expression
      subject.expression.should == "22 * x + 6"
    end
    it "should leave non-standard expressions alone, to fail validation later" do
      subject.expression="z + y = 22 * x + 6"
      subject.normalize_expression
      subject.expression.should == "z + y = 22 * x + 6"
    end

  end
  describe "#to_hash" do
    let(:expected_hash) { 
      {"type"=>"PredefinedGraphPane", "title"=>nil, "yLabel"=>nil, "yUnits"=>nil, "yMin"=>nil, "yMax"=>nil, "xLabel"=>nil, "xUnits"=>nil, "xMin"=>nil, "xMax"=>nil, "yTicks"=>nil, "xTicks"=>nil, "xPrecision"=>0.1, "yPrecision"=>0.1, "data"=>[], "expression"=>"", "lineSnapDistance"=>0.1, "lineType"=>"none", "pointType"=>"dot", "showCrossHairs"=>false, "showToolTipCoords"=>false, "showGraphGrid"=>false}
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
        {"type"=>"PredefinedGraphPane", "title"=>"x in terms of y", "yLabel"=>"y", "yUnits"=>nil, "yMin"=>0.0, "yMax"=>1.0, "xLabel"=>"x", "xUnits"=>nil, "xMin"=>0.0, "xMax"=>10.0, "yTicks"=>0.1, "xTicks"=>1.0, "xPrecision"=>0.1, "yPrecision"=>0.1, "data"=>[[1.0, 1.0, 2.0, 2.0, 3.0, 3.0, 4.0, 4.0]], "expression"=>"y  = 22 * x - 3", "lineSnapDistance"=>0.1, "lineType"=>"none", "pointType"=>"dot", "showCrossHairs"=>false, "showToolTipCoords"=>false, "showGraphGrid"=>false}
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
    describe "expression" do
      describe "passing expressions" do
        it "validates null expressions" do
          test = PredefinedGraphPane.new(
            :title     => "title",
            :y_label   => "y",
            :y_min     =>  0 ,
            :y_max     =>  10,
            :y_ticks    => 10,
            :x_label     => "x",
            :x_min       => 0,
            :x_max       => 10,
            :x_ticks     => 10,
            :expression => "")
          test.should be_valid
        end
        it "validates  y = m * x + b" do
          test = PredefinedGraphPane.new(
            :title     => "title",
            :y_label   => "y",
            :y_min     =>  0 ,
            :y_max     =>  10,
            :y_ticks    => 10,
            :x_label     => "x",
            :x_min       => 0,
            :x_max       => 10,
            :x_ticks     => 10,
            :expression => "0.3 * x + 4")
          test.should be_valid
          test = PredefinedGraphPane.new(
            :title     => "title",
            :y_label   => "y",
            :y_min     =>  0 ,
            :y_max     =>  10,
            :y_ticks    => 10,
            :x_label     => "x",
            :x_min       => 0,
            :x_max       => 10,
            :x_ticks     => 10,
            :expression => "y = x + 5")
          test.should be_valid
        end
      end
      describe "more complicated expression" do
        it "passes pow(x,10) * (4.0 * atan( log(x) + 3))" do
            test = PredefinedGraphPane.new(
            :title     => "title",
            :y_label   => "y",
            :y_min     =>  0 ,
            :y_max     =>  10,
            :y_ticks    => 10,
            :x_label     => "x",
            :x_min       => 0,
            :x_max       => 10,
            :x_ticks     => 10,
            :expression => "pow(x,10) * (4.0 * atan( log(x) + 3))")
          test.should be_valid
        end
      end
      describe "failing expressions" do
        it "fails z = y + x + 3" do
          test = PredefinedGraphPane.new(
            :title     => "title",
            :y_label   => "y",
            :y_min     =>  0 ,
            :y_max     =>  10,
            :y_ticks    => 10,
            :x_label     => "x",
            :x_min       => 0,
            :x_max       => 10,
            :x_ticks     => 10,
            :expression => "z = y + x + 3")
          test.should_not be_valid
        end
        it "console.log('foo');" do
          test = PredefinedGraphPane.new(
            :title     => "title",
            :y_label   => "y",
            :y_min     =>  0 ,
            :y_max     =>  10,
            :y_ticks    => 10,
            :x_label     => "x",
            :x_min       => 0,
            :x_max       => 10,
            :x_ticks     => 10,
            :expression => "console.log('foo');")
          test.should_not be_valid
        end
      end
    end
  end
end
