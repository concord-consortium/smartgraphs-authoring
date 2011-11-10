class RangeVisualPrompt < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name  :string
    x_min :float
    x_max :float
    color :string
    timestamps
  end

  has_one :text_hint_prompt, :as => :prompt, :dependent => :destroy

  has_one :text_hint, :through => :text_hint_prompt
  reverse_association_of :text_hint, 'TextHint#range_visual_prompts'

  has_one :initial_prompt_prompt, :as => :prompt, :dependent => :destroy
  has_one :initial_prompt_sequence, :through => :initial_prompt_prompt, :source => :pick_a_point_sequence
  reverse_association_of :initial_prompt_sequence, 'PickAPointSequence#initial_range_visual_prompts'

  has_one :give_up_prompt, :as => :prompt, :dependent => :destroy
  has_one :give_up_sequence, :through => :give_up_prompt, :source => :pick_a_point_sequence
  reverse_association_of :give_up_sequence, 'PickAPointSequence#give_up_range_visual_prompts'

  has_one :confirm_correct_prompt, :as => :prompt, :dependent => :destroy
  has_one :confirm_correct_sequence, :through => :confirm_correct_prompt, :source => :pick_a_point_sequence
  reverse_association_of :confirm_correct_sequence, 'PickAPointSequence#confirm_range_visual_prompts'

  def to_hash
    hash = {
      'type' => 'RangeVisualPrompt',
      'name' => name,
      'color' => color
    }

    hash['xMin'] = x_min if x_min
    hash['xMax'] = x_max if x_max

    hash
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
