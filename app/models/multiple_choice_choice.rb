class MultipleChoiceChoice < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name      :string
    #position :integer
    correct   :boolean
    feedback  :text
    timestamps
  end
  inline_booleans true
  acts_as_list
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
    case field.to_s
    when 'feedback'
      return false if multiple_choice_sequence.use_sequential_feedback
    end
    true
  end

end
