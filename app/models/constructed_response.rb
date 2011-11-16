class ConstructedResponse < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title           :string
    initial_content :text
    timestamps
  end

  belongs_to :constructed_response_sequence

  acts_as_list
  never_show :position

  def to_hash
    hash = {
      'type' => 'ConstructedResponse'
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
