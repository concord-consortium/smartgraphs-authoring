require 'spec_helper'

describe DataSet do
  describe "#reformat_data_text" do
    it "should run on empty DataSet" do
      empty_data = ""
      subject.reformat_data_text
      subject.data.should match empty_data
    end
    it "should return comma separated data" do
      subject.data = "1,2\n1,3"
      subject.reformat_data_text
      subject.data.should == "1,2\n1,3"
    end
    it "tabs should be replaced by comma separated data" do
      subject.data = "1\t2\n1\t3"
      subject.reformat_data_text
      subject.data.should == "1,2\n1,3"
    end
    it "extra lines should be stripped" do
      subject.data = "\n\n1,2\n1,3\n\n"
      subject.reformat_data_text
      subject.data.should == "1,2\n1,3"
    end
    it "extra space should be stripped" do
      subject.data = "1 , 2  \n 1 , 3"
      subject.reformat_data_text
      subject.data.should == "1,2\n1,3"
    end
  end

  describe "#reformat_expression" do
    it "should get rid of the left side of y =" do
      subject.expression="y = 23 * x + 4"
      subject.reformat_expression
      subject.expression.should == "23 * x + 4"
    end
    it "should leave well enough alone" do
      subject.expression="22 * x + 6"
      subject.reformat_expression
      subject.expression.should == "22 * x + 6"
    end
    it "should leave non-standard expressions alone, to fail validation later" do
      subject.expression="z + y = 22 * x + 6"
      subject.reformat_expression
      subject.expression.should == "z + y = 22 * x + 6"
    end
  end

  describe "#to_hash" do
    describe "default values" do
      let(:expected_hash) {
        {"type"=>"datadef", "name"=>nil, "yUnits"=>nil, "xUnits"=>nil, "xPrecision"=>0.1, "yPrecision"=>0.1, "lineSnapDistance"=>0.1, "lineType"=>"none", "pointType"=>"dot", "data"=>[], "expression"=>"", 'derivativeOf' => nil,  'piecewiseLinear' => nil}
      }
      it "should match our expected hash" do
        subject.to_hash.should == expected_hash
      end
    end
    describe "a more interesting instance" do
      # TODO: Validate that a dataset with a derivative_of value copies properly
    end
  end

  describe "#expression_to_hash" do
    it "should prefix the expression with 'y = ' to the expression if the expression doesn't start with 'y ='" do
      test = DataSet.new(
        :name     => "name",
        :expression => "x + 5")
      test.expression_to_hash.should == "y = x + 5"
    end
    describe "it should not prefix an additional 'y = ' to the expression if the expression already starts with 'y ='" do
      test = DataSet.new(
        :name     => "name",
        :expression => "    y   = x + 5")
      test.expression_to_hash.should == "y = x + 5"
    end
  end

  describe "validations" do
    describe "expression" do
      describe "passing expressions" do
        it "validates null expressions" do
          test = DataSet.new(
            :name     => "name",
            :expression => "")
          test.should be_valid
        end
        it "validates  y = m * x + b" do
          test = DataSet.new(
            :name     => "name",
            :expression => "0.3 * x + 4")
          test.should be_valid
          test = DataSet.new(
            :name     => "name",
            :expression => "y = x + 5")
          test.should be_valid
        end
      end
      describe "more complicated expression" do
        it "passes pow(x,10) * (4.0 * atan( log(x) + 3))" do
            test = DataSet.new(
            :name     => "name",
            :expression => "pow(x,10) * (4.0 * atan( log(x) + 3))")
          test.should be_valid
        end
      end
      describe "failing expressions" do
        it "fails z = y + x + 3" do
          test = DataSet.new(
            :name     => "name",
            :expression => "z = y + x + 3")
          test.should_not be_valid
        end
        it "fails 'console.log('foo');'" do
          test = DataSet.new(
            :name     => "name",
            :expression => "console.log('foo');")
          test.should_not be_valid
        end
      end
    end
  end
end
