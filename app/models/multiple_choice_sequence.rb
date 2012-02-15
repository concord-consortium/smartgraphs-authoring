class MultipleChoiceSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    initial_prompt :text
    give_up :text
    confirm_correct :text
    use_sequential_feedback :boolean, :default => true
    timestamps
  end

  has_one :page_sequence, :as => :sequence, :dependent => :destroy

  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#multiple_choice_sequences'
  
  has_many :multiple_choice_choices, :dependent => :destroy, :order => :position


  has_many :multiple_choice_hints, :dependent => :destroy, :order => :position

  children :multiple_choice_choices, :multiple_choice_hints
  #children  :multiple_choice_hints, :multiple_choice_choices

  def to_hash
    {
      'type' => type,
      'initialPrompt' => initial_prompt,
      'choices' => multiple_choice_choices.map { |c| c.to_hash },
      'correctAnswerIndex' => correct_answer_index,
      'giveUp' => give_up,
      'confirmCorrect' => confirm_correct,
      'hints' => hints
    }
  end

  def type
    if use_sequential_feedback then
      'MultipleChoiceWithSequentialHintsSequence'
    else
      'MultipleChoiceWithCustomHintsSequence'
    end
  end
  
  def hints
    if use_sequential_feedback
      return multiple_choice_hints.map { |h| h.to_hash   }
    end
    multiple_choice_choices.map { |c| c.hint_hash }
  end

  # return the first correct answer
  def correct_answer
    multiple_choice_choices.detect { |a| a.correct }
  end

  def correct_answer_index
    if correct_answer
      return correct_answer.position - 1
    end
    # TODO: What do we do? Its an error condition right?
  end

  def has_correct_answer?
    return !correct_answer.nil?
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
