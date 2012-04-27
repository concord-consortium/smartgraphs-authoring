module SgPermissions
  
  module ClassMethods
    # sg_parent :activity  
    # sg_parent :any_sequence
    # sg_parent :any_prompt
    def sg_parent(symbol)
      if symbol == :any_sequence
        define_method "sg_parent" do
          numeric_sequence || pick_a_point_sequence
        end
      elsif symbol == :any_prompt
        define_method "sg_parent" do
          text_hint_prompt || initial_prompt_prompt || confirm_correct_prompt || give_up_prompt 
        end
      else
        define_method "sg_parent" do
          return self.send symbol
        end
      end
    end
  end

  def self.included(base)
    puts "including #{self} in #{base}"
    base.class_eval do
      belongs_to :owner, :class_name => "User"
    end
    base.extend(ClassMethods)
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