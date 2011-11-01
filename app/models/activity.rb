class Activity < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    timestamps
  end

  has_many :pages, :order => :position

  children :pages

  def to_hash
    {
      'type' => 'Activity',
      'name' => name,
      'pages' => pages.map do |page|
        page.to_hash
      end
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
