require 'spec_helper'

describe MultipleChoiceSequence do

  describe "#to_hash" do
    before :each do
      @initial_prompt = "intial prompt"
      @giveup = "maybe you should just give up"
      @confirm_correct = "thats right! Correct!"
      @choices = 1.upto(4).map { |i|
        MultipleChoiceChoice.new(
          :name => "choice #{i}",
          :correct => (i == 2 ? true : false),
          :feedback => "feedback for choice #{i}"
        )
      }
      @hints = 1.upto(4).map { |i|
        MultipleChoiceHint.new(:name => "feedback #{i}")
      }
      @data_set = mock_model(DataSet, {
        :name => "dataSetA"
      })
      @multi_choice = MultipleChoiceSequence.create(
        :initial_prompt => @initial_prompt,
        :give_up => @giveup,
        :confirm_correct => @confirm_correct,
        :use_sequential_feedback => true,
        :multiple_choice_choices => @choices,
        :multiple_choice_hints => @hints,
        :data_set => @data_set
      )
    end
    it "should match the format specified by the generator project" do
        json = @multi_choice.to_hash.to_json
        the_hash = JSON.parse(json)
        assert_equal the_hash['initialPrompt'], { 'text' => @multi_choice.initial_prompt }
        assert_equal the_hash['correctAnswerIndex'], @multi_choice.correct_answer_index
        assert_equal the_hash['giveUp'], { 'text' => @multi_choice.give_up }
        assert_equal the_hash['confirmCorrect'], { 'text' => @multi_choice.confirm_correct }
        assert_equal the_hash['choices'][1], @choices[1].name
        assert_equal the_hash['dataSetName'], @data_set.name
    end
    describe "when using sequential hints" do
      it "should match the format specified by the generator project" do
        json = @multi_choice.to_hash.to_json
        the_hash = JSON.parse(json)
        assert_equal the_hash['hints'].first['name'], @hints.first.name
        assert_equal the_hash['hints'].last['name'], @hints.last.name
      end
    end
    describe "when using choice based hints" do
      it "should match the format specified by the generator project" do
        @multi_choice.use_sequential_feedback = false
        json = @multi_choice.to_hash.to_json
        the_hash = JSON.parse(json)
        assert_equal the_hash['hints'].first['name'], @choices.first.hint_name
        assert_equal the_hash['hints'].first['text'], @choices.first.feedback
        assert_equal the_hash['hints'].first['choiceIndex'], @choices.first.position - 1
        assert_equal the_hash['hints'].last['name'], @choices.last.hint_name
        assert_equal the_hash['hints'].last['text'], @choices.last.feedback
        assert_equal the_hash['hints'].last['choiceIndex'], @choices.last.position - 1
      end
    end

  end
end
