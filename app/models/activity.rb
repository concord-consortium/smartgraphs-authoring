class Activity < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name        :string
    author_name :string
    timestamps
  end

  has_many :pages, :order => :position

  children :pages

  def to_hash
    {
      'type' => 'Activity',
      'name' => name,
      'authorName' => author_name,
      'pages' => pages.map(&:to_hash),
      'units' => Unit.find(:all).map(&:to_hash)
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
