class ConstructedResponseSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title         :string
    initial_prompt :text
    timestamps
  end

  has_one :page_sequence, :as => :sequence, :dependent => :destroy

  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#constructed_response_sequences'

  has_many :constructed_responses, :order => :position

  children :constructed_responses

  def to_hash
    hash = {
      'type' => 'ConstructedResponseSequence',
      'initialPrompt' => initial_prompt
    }
    if constructed_responses
      hash['responses'] = constructed_responses.map{|cr| cr.to_hash }
    else
      hash['responses'] = []
    end
    hash
  end

  after_create :create_default_constructed_response

  def create_default_constructed_response
    default = ConstructedResponse.create(:title => "Default", :constructed_response_sequence => self)
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
