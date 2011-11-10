class NumericSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title           :string
    initial_prompt  :text
    give_up         :text
    confirm_correct :text
    correct_answer  :float
    timestamps
  end

  has_one :page_sequence, :as => :sequence, :dependent => :destroy

  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#numeric_sequences'

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
