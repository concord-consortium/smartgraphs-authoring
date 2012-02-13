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
      'type' => 'MultipleChoiceWithSequentialHintsSequence',
      'initialPrompt' => initial_prompt,
      'choices' => multiple_choice_choices.map { |c| c.to_hash },
      'correctAnswerIndex' => correct_answer_index,
      'giveUp' => give_up,
      'confirmCorrect' => confirm_correct,
      'hints' => multiple_choice_hints.map { |h| h.to_hash }
    }
  end

  # return the first correct answer
  def correct_answer
    multiple_choice_choices.detect { |a| a.correct }
  end

  def correct_answer_index
    return correct_answer.position
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
