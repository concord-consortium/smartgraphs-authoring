require 'spec_helper'

describe PickAPointSequence do
  
  describe "#to_hash" do
    before(:each) do
      params = {
        :title  => "pick a point",
        :initial_prompt  => "where is the midpoint",
        :give_up => "sorry",
        :confirm_correct => "correct",  
        :correct_answer_x_min => 0.3  
      }
      @sequence = PickAPointSequence.new(params) 
    end
  
    describe "json format" do
      it "should include unquoted null values" do
        @sequence.correct_answer_x_min.should == 0.3
        json = JSON.pretty_generate(JSON.parse(@sequence.to_hash.to_json))
        json.should match(/null/)
        json.should_not match (/"null"/)
      end
    end
  end

end
