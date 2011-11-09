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
