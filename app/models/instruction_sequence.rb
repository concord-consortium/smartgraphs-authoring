class InstructionSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    text :text
    timestamps
  end

  has_one :page_sequence, :as => :sequence

  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#instruction_sequences'

  def to_hash
    {
      'type' => 'InstructionSequence',
      'text' => text
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
