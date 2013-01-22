require 'spec_helper'

describe NumericSequence do
  describe "#to_hash" do
    before(:each) do
      data_set = mock_model(DataSet, {
        :name => "dataSetA"
      })

      params = {
        :title  => "pick a point",
        :initial_prompt  => "where is the midpoint",
        :give_up => "sorry",
        :confirm_correct => "correct",
        :correct_answer => 0.3,
        :data_set => data_set
      }

      @sequence = NumericSequence.new(params)
    end

    describe "json format" do
      it "should include unquoted null values" do
        @sequence.correct_answer = nil
        json = JSON.pretty_generate(JSON.parse(@sequence.to_hash.to_json))
        json.should match(/null/)
        json.should_not match (/"null"/)
      end
    end

    describe "the hash" do
      subject do
        @sequence.to_hash
      end

      # TODO: below simply represents tests in progress; could write single expectation
      # for entire hash.
      it "correctly represents the give-up prompt" do
        subject.should have_key 'giveUp'
        subject['giveUp'].should == { 'text' => "sorry" }
      end

      it "correctly represents the included dataset" do
        subject.should have_key 'dataSetName'
        subject['dataSetName'].should == "dataSetA"
      end
    end
  end

end
