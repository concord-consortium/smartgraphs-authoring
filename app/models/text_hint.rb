class TextHint < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    text :text
    timestamps
  end

  has_one :sequence_hint, :as => :hint, :dependent => :destroy

  has_one :pick_a_point_sequence, :through => :sequence_hint
  reverse_association_of :pick_a_point_sequence, 'PickAPointSequence#text_hints'

#  has_one :give_up_sequence, :as => :give_up_hint
#  has_one :confirm_correct_sequence, :as => :confirm_correct_hint

  def to_hash
    {
      'name' => name.to_s,
      'text' => text.to_s
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
