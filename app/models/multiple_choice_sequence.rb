class MultipleChoiceSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    initial_prompt :text
    timestamps
  end
  has_one :page_sequence, :as => :sequence, :dependent => :destroy

  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#multiple_choice_sequences'

  def to_hash
    {
      'type' => 'MultipleChoiceWithSequentialHintsSequence',
      'initialPrompt' => initial_prompt
    }
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
