require 'spec_helper'

describe LineConstructionSequence do

  describe "default values" do
    before :each do
      @instance = LineConstructionSequence.create
    end
    it "should be valid" do
      @instance.should be_valid
    end

    it "should get the defaults from the class defaults" do
      LineConstructionSequence.defaults.each_pair do |key,value|
        @instance.send(key).should == value
      end
    end

    it "should produce the correct hash with default values" do
      expected_hash = {
        "type"                => "LineConstructionSequence",
        "slope"               => 1.0,
        "slopeTolerance"      => 0.1,
        "yIntercept"          => 0.0,
        "yInterceptTolerance" => 0.1,
        "initialPrompt"       => "Construct a line with y-interept 0.0, with slope 1.0.",
        "confirmCorrect"      => "That is Correct.",
        "slopeIncorrect"      => "Incorrect, your slope is wrong.",
        "yInterceptIncorrect" => "Incorrect, your y-intercept is wrong.",
        "allIncorrect"        => "Incorrect. Try again.",
        "showCrossHairs"      => true,
        "showToolTipCoords"   => false,
        "showGraphGrid"       => true,
        "xPrecision"          => 0.1,
        "yPrecision"          => 0.1
      }
      @instance.to_hash.should == expected_hash
    end
  end
  
end
