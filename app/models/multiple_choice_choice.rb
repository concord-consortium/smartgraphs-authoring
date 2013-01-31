class MultipleChoiceChoice < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :multiple_choice_sequence
  
  fields do
    name      :string
    #position :integer
    correct   :boolean
    feedback  :text
    timestamps
  end
  inline_booleans true
  acts_as_list :scope => :multiple_choice_sequence
  belongs_to :multiple_choice_sequence, :index => 'multiple_choice_sequence_multiple_choice_choice_index'


  def to_hash
    name
  end

  def hint_hash
    {
      "name" => hint_name,
      "choiceIndex" => (position - 1),
      "text" => feedback
    }
  end

  def hint_name
    "Choice #{name} Hint"
  end

  def view_permitted?(field)
    case field.to_s
    when 'feedback'
      return false if multiple_choice_sequence.use_sequential_feedback
    when 'correct'
      return false if multiple_choice_sequence.has_correct_answer? && !self.correct
    end
    return true
  end

end
