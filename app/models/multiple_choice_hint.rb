class MultipleChoiceHint < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :multiple_choice_sequence
  
  fields do
    name      :string
    hint_text :text
    timestamps
  end

  acts_as_list
  belongs_to :multiple_choice_sequence, :index => 'multiple_choice_sequence_multiple_choice_hint_index'

  # --- Permissions --- #


  def to_hash
    { 
      'name' => name,
      'text' => hint_text
    }
  end

end
