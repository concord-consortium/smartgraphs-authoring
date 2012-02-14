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
      'AuthorName' => author_name_for_hash,
      'pages' => pages.map(&:to_hash),
      'units' => Unit.find(:all).map(&:to_hash)
    }
  end

  # --- Permissions --- #

  def author_name_for_hash
    return author_name unless author_name.nil? || author_name.empty?
    return "SmartGraphs Authoring Team"
  end

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
