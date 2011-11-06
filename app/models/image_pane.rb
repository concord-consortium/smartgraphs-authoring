class ImagePane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    url :string
    license :string
    attribution :string
    timestamps
  end

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#image_panes'

  def to_hash
    {
      'type' => 'ImagePane',
      'name' => name,
      'url' => url,
      'license' => license,
      'attribution' => attribution
    }
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
