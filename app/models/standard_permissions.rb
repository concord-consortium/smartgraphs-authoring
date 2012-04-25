module StandardPermissions
  
  def self.included(base)
    base.class_eval {
      belongs_to :owner, :class_name => "User"
      
      # parent :activity
      def self.parent(symbol)
        define_method "parent" do
          return self.send symbol
        end
      end

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

  def edit_permitted?(attribute)
    return true if acting_user.administrator?
    return false if attribute == :owner
    return owner_is?(acting_user)
  end

  def children
    child_many = self.class.reflect_on_all_associations(:has_many)
    child_many.map! { |x| x.name }

    kids = child_many.flatten
    kids.map! do |key| 
      results = self.send(key)
      results.map! do |k|
        if k.respond_to? :children
          [k, k.children]
        else
          k
        end
      end
    end
    kids.flatten.uniq
  end

end