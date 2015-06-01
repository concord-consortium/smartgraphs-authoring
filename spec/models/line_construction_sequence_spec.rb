require 'spec_helper'

describe LineConstructionSequence do

  describe "default values" do
    before :each do
      data_set = mock_model(DataSet, {
        :name => "dataSetA"
      })

      @instance = LineConstructionSequence.create(:data_set => data_set)
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
      expected_hash = {
        "type"                => "LineConstructionSequence",
        "slope"               => 1.0,
        "slopeTolerance"      => 0.1,
        "yIntercept"          => 0.0,
        "yInterceptTolerance" => 0.1,
        "maxAttempts"         => 3,
        "initialPrompt"       => "Construct a line with y-interept 0.0, with slope 1.0.",
        "confirmCorrect"      => "That is correct.",
        "slopeIncorrect"      => "Incorrect, your slope is wrong.",
        "yInterceptIncorrect" => "Incorrect, your y-intercept is wrong.",
        "allIncorrect"        => "Incorrect. Try again.",
        "giveUp"              => "The correct answer is shown.",
        "dataSetName"         => 'dataSetA'
        # these moved to GraphPane....
        # "showCrossHairs"      => true,
        # "showToolTipCoords"   => false,
        # "showGraphGrid"       => true
      }
      @instance.to_hash.should == expected_hash
    end
  end

end
