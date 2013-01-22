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

  def sg_activity
    current_top = self
    while (current_top.respond_to? :sg_parent)
      current_top = current_top.send(:sg_parent)
      throw "can't find activity in #{current_top.class.to_s}" if current_top.nil?
      return current_top if current_top.kind_of? Activity
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def is_owner?(user)
    activity = self.sg_activity
    if activity.nil?
      message = "cant find owner for #{self}"
      Rails.log message
      puts message
      return true
    end
    return activity.is_owner?(user)
  end

  def create_permitted?
    if acting_user.signed_up?
      return true
      # self.is_owner?(acting_user)
    end
    return false
  end

  def update_permitted?
   return true if acting_user.administrator?
   return true if self.is_owner?(acting_user)
   return false
  end

  def destroy_permitted?
   return true if acting_user.administrator?
   return true if self.is_owner?(acting_user)
   return false
  end

  def view_permitted?(field)
    true
  end

  def edit_permitted?(attribute)
    return true if acting_user.administrator?
    return self.is_owner?(acting_user)
  end

end