require 'spec_helper'

describe PickAPointSequence do
  
  describe "#to_hash" do
    let (:data_set) { mock_model(DataSet, { :name => "dataSetA" }) }
    let (:params)   { {
        :title  => "pick a point",
        :initial_prompt  => "where is the midpoint",
        :give_up => "sorry",
        :confirm_correct => "correct",  
        :correct_answer_x_min => 0.3,
        :data_set => data_set
      }
    }
    let (:sequence) { PickAPointSequence.new(params) }

    describe "json format" do
      it "should include unquoted null values" do
        json = JSON.pretty_generate(JSON.parse(sequence.to_hash.to_json))
        json.should match(/null/)
        json.should_not match (/"null"/)
      end
    end

    describe "the hash" do
      let (:output_hash) { sequence.to_hash }
      
      # TODO: below simply represents tests in progress; could write single expectation 
      # for entire hash.
      it "correctly represents the give-up prompt" do 
        output_hash.should have_key 'giveUp'
        output_hash['giveUp'].should == { 'text' => "sorry" }
      end

      it "correctly represents the included dataset" do 
        output_hash.should have_key 'dataSetName'
        output_hash['dataSetName'].should == "dataSetA"
      end
    end
  end

end
