class PickAPointSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title          :string
    initialPrompt  :text
    correctAnswerX :float
    correctAnswerY :float
    timestamps
  end

  has_one :page_sequence, :as => :sequence, :dependent => :destroy

  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#pick_a_point_sequences'

  has_many :sequence_hints, :order => :position
  has_many :text_hints, :through => :sequence_hints, :source => :hint, :source_type => 'TextHint'
  reverse_association_of :text_hints, 'TextHint#pick_a_point_sequence'

#  belongs_to :give_up_hint, :polymorphic => true, :index => 'index_give_up_hints'
#  belongs_to :confirm_correct_hint, :polymorphic => true, :index => 'index_confirm_correct_hints'

  children :sequence_hints

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
