class Activity < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  
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

  def after_user_new
    self.owner = acting_user
    self.author_name ||= acting_user.name
  end

  def copy_activity(user = self.owner)
    hash_rep = self.to_hash
    the_copy = Activity.from_hash(hash_rep)
    the_copy.owner = user
    the_copy.save
    return the_copy
  end
  
end