module StandardPermissions
  
  def self.included(base)
    base.class_eval {
      belongs_to :owner, :class_name => "User"     
    }
  end

  def after_user_new 
    self.owner = acting_user
  end

  def create_permitted?
    acting_user.signed_up?
  end

  def update_permitted?
   return true if acting_user.administrator?
   return true if owner_is?(acting_user)
   return false
  end

  def destroy_permitted?
   return true if acting_user.administrator?
   return true if owner_is?(acting_user)
   return false
  end

  def view_permitted?(field)
    true
  end
end