class ConstructedResponseSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title         :string
    initial_prompt :text
    initial_content :text
    timestamps
  end

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
