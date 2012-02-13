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
      @multi_choice = MultipleChoiceSequence.create(
        :initial_prompt => @initial_prompt,
        :give_up => @giveup,
        :confirm_correct => @confirm_correct,
        :use_sequential_feedback => true,
        :multiple_choice_choices => @choices,
        :multiple_choice_hints => @hints
      )
    end
    it "should match the format specified by the generator project" do
        json = @multi_choice.to_hash.to_json
        the_hash = JSON.parse(json)
        assert_equal the_hash['initialPrompt'], @multi_choice.initial_prompt
        assert_equal the_hash['correctAnswerIndex'], @multi_choice.correct_answer_index
        assert_equal the_hash['giveUp'], @multi_choice.give_up
        assert_equal the_hash['confirmCorrect'], @multi_choice.confirm_correct
        assert_equal the_hash['choices'][1], @choices[1].name
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

__END__
{
"type": "MultipleChoiceWithSequentialHintsSequence",
  "initialPrompt": "<p>Which of the following choices is choice \"B\"?</p>",
  "choices": [
    "Choice A",
    "Choice B",
    "Choice C"
  ],
  "correctAnswerIndex": 1,
  "giveUp": {
    "text": "<p>Incorrect. The correct choice B is choice B.</p>"
  },
  "confirmCorrect": {
    "text": "<p>That's right. I wanted choice B, you gave it to me.</p>"
  },
  "hints": [
    {
      "name": "Hint 1",
      "text": "<p>You can try harder than that.</p>"
    },
    {
      "name": "Hint 2",
      "text": "<p>I'm starting to worry about you.</p>"
    },
    {
      "name": "Hint 3",
      "text": "<p>C'mon, you can do it. Or so I used to think.</p>"
    }
  ]
}
