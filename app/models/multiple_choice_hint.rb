class MultipleChoiceHint < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name      :string
    hint_text :text
    timestamps
  end

  acts_as_list
  belongs_to :multiple_choice_sequence, :index => 'multiple_choice_sequence_multiple_choice_hint_index'

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def to_hash
    { 
      'name' => name,
      'text' => hint_text
    }
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
