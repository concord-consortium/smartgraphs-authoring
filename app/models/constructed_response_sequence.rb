class ConstructedResponseSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :page
  
  fields do
    title         :string
    initial_prompt :text
    initial_content :text
    timestamps
  end
  
  validates :title, :presence => true

  has_one :page_sequence, :as => :sequence, :dependent => :destroy

  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#constructed_response_sequences'

  def to_hash
    hash = {
      'type' => 'ConstructedResponseSequence',
      'initialPrompt' => initial_prompt,
    }
    hash['initialContent'] = initial_content if initial_content
    hash
  end

end
