class RangeVisualPrompt < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :any_prompt
  
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

  has_one :initial_prompt_numeric_sequence, :through => :initial_prompt_prompt, :source => :numeric_sequence
  reverse_association_of :initial_prompt_numeric_sequence, 'NumericSequence#initial_range_visual_prompts'

  has_one :initial_prompt_multiple_choice_sequence, :through => :initial_prompt_prompt, :source => :multiple_choice_sequence
  reverse_association_of :initial_prompt_multiple_choice_sequence, 'MultipleChoiceSequence#initial_range_visual_prompts'

  has_one :give_up_prompt, :as => :prompt, :dependent => :destroy
  has_one :give_up_sequence, :through => :give_up_prompt, :source => :pick_a_point_sequence
  reverse_association_of :give_up_sequence, 'PickAPointSequence#give_up_range_visual_prompts'

  has_one :give_up_numeric_sequence, :through => :give_up_prompt, :source => :numeric_sequence
  reverse_association_of :give_up_numeric_sequence, 'NumericSequence#give_up_range_visual_prompts'

  has_one :give_up_multiple_choice_sequence, :through => :give_up_prompt, :source => :multiple_choice_sequence
  reverse_association_of :give_up_multiple_choice_sequence, 'MultipleChoiceSequence#give_up_range_visual_prompts'

  has_one :confirm_correct_prompt, :as => :prompt, :dependent => :destroy
  has_one :confirm_correct_sequence, :through => :confirm_correct_prompt, :source => :pick_a_point_sequence
  reverse_association_of :confirm_correct_sequence, 'PickAPointSequence#confirm_range_visual_prompts'

  has_one :confirm_correct_numeric_sequence, :through => :confirm_correct_prompt, :source => :numeric_sequence
  reverse_association_of :confirm_correct_numeric_sequence, 'NumericSequence#confirm_range_visual_prompts'

  has_one :confirm_correct_multiple_choice_sequence, :through => :confirm_correct_prompt, :source => :multiple_choice_sequence
  reverse_association_of :confirm_correct_multiple_choice_sequence, 'MultipleChoiceSequence#confirm_range_visual_prompts'

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

end
