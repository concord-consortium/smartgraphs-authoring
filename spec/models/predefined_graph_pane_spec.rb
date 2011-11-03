require 'spec_helper'

describe PredefinedGraphPane do
  describe "#normalize_data" do
    it "should run on empty graph" do
      graph = PredefinedGraphPane.new
      graph.should_not be_nil
      graph.normalize_data
    end
    it "should return comma separated data" do
      graph = PredefinedGraphPane.new
      graph.data = "1,2\n1,3"
      graph.normalize_data
      graph.data.should == "1,2\n1,3"
    end
    it "tabs should be replaced by comma separated data" do
      graph = PredefinedGraphPane.new
      graph.data = "1\t2\n1\t3"
      graph.normalize_data
      graph.data.should == "1,2\n1,3"
    end
    it "extra lines should be stripped" do
      graph = PredefinedGraphPane.new
      graph.data = "\n\n1,2\n1,3\n\n"
      graph.normalize_data
      graph.data.should == "1,2\n1,3"
    end
    it "extra space should be stripped" do
      graph = PredefinedGraphPane.new
      graph.data = "1 , 2  \n 1 , 3"
      graph.normalize_data
      graph.data.should == "1,2\n1,3"
    end
  end
end
