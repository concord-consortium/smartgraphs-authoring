class TextHint < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  include SgSequencePrompts
  sg_parent :any_sequence
  
  fields do
    name :string
    text :raw_html
    timestamps
  end

  has_one :sequence_hint, :as => :hint, :dependent => :destroy

  has_one :pick_a_point_sequence, :through => :sequence_hint
  reverse_association_of :pick_a_point_sequence, 'PickAPointSequence#text_hints'

  has_one :numeric_sequence, :through => :sequence_hint
  reverse_association_of :numeric_sequence, 'NumericSequence#text_hints'

  has_many :text_hint_prompts
  has_many :range_visual_prompts, :through => :text_hint_prompts, :source => :prompt, :source_type => 'RangeVisualPrompt'
  reverse_association_of :range_visual_prompts, 'RangeVisualPrompt#text_hint'

  has_many :point_circle_visual_prompts, :through => :text_hint_prompts, :source => :prompt, :source_type => 'PointCircleVisualPrompt'
  reverse_association_of :point_circle_visual_prompts, 'PointCircleVisualPrompt#text_hint'

  has_many :point_axis_line_visual_prompts, :through => :text_hint_prompts, :source => :prompt, :source_type => 'PointAxisLineVisualPrompt'
  reverse_association_of :point_axis_line_visual_prompts, 'PointAxisLineVisualPrompt#text_hint'

  children :text_hint_prompts

  def to_hash
    hash = {
      'name' => name.to_s,
      'text' => text.to_s
    }
    unless text_hint_prompts.empty?
      hash['visualPrompts'] = text_hint_prompts.map do |prompt|
        prompt.prompt.to_hash
      end
    end
    hash
  end

end
