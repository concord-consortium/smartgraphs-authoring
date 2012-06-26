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

    it "should produce the correct hash" do
      @expected = {
        "type"                => "LineConstructionSequence",
        "slope"               => 1,
        "slopeTolerance"      => 0.1,
        "yIntercept"          => 0,
        "yInterceptTolerance" => 0.1,
        "intialPrompt"        => LineConstructionSequence.defaults['initial_prompt'],
        "confirmCorrect"      => LineConstructionSequence.defaults['confirm_correect'],
        "slopeIncorrect"      => LineConstructionSequence.defaults['slope_incorrect'],
        "yInterceptIncorrect" => LineConstructionSequence.defaults['y_intercept_incorrect'],
        "allIncorrect"        => LineConstructionSequence.defaults['all_incorect'],
        "showCrossHairs"      => true,
        "showToolTipCoords"   => false,
        "showGraphGrid"       => true
      }
    end
  end
  
end
