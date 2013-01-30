require 'spec_helper'

describe BestFitSequence do
  describe "default values" do
    before :each do
      data_set = mock_model(DataSet, {
        :name => "dataSetA"
      })
      user_data = mock_model(DataSet, { :name => "dataSetB" })

      @instance = BestFitSequence.create(:data_set => data_set, :learner_data_set => user_data)
    end
    
    it "is valid" do
      @instance.should be_valid
    end
    
    it "produces the correct hash" do
      expected_hash = {
        "type"=> "BestFitSequence",
        "dataSetName"=> "dataSetA",
        "learnerDataSet"=> "dataSetB",
        "correctTolerance"=> 0.1,
        "closeTolerance"=> 0.2,
        "initialPrompt"=> "Find the line of best fit for this scatter plot.",
        "incorrectPrompt"=> "Your estimate can be better; try again.",
        "closePrompt"=> "Your estimate is close; try again.",
        "confirmCorrect"=> "You made an excellent estimate.",
        "maxAttempts"=> 4,
        "giveUp" => "Your estimate was not correct."
        
      }
      @instance.to_hash.should == expected_hash
    end
  end
end
