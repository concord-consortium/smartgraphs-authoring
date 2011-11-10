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

  has_many :text_hint_prompts
  has_many :range_visual_prompts, :through => :text_hint_prompts, :source => :prompt, :source_type => 'RangeVisualPrompt'
  reverse_association_of :range_visual_prompts, 'RangeVisualPrompt#text_hint'

  children :text_hint_prompts

  def to_hash
    hash = {
      'name' => name.to_s,
      'text' => text.to_s
    }
    unless range_visual_prompts.empty?
      hash['visualPrompts'] = range_visual_prompts.map do |prompt|
        prompt.to_hash
      end
    end
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
