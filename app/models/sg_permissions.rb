module SgPermissions
  
  module ClassMethods
    # sg_parent :activity  
    # sg_parent :any_sequence
    # sg_parent :any_prompt
    def sg_parent(symbol)
      if symbol == :any_sequence
        define_method "sg_parent" do
          begin
            numeric_sequence || pick_a_point_sequence || multiple_choice_sequence || best_fit_sequence || slope_tool_sequence || constructed_response_sequence || instruction_sequence
          rescue NameError
            # This might be a specific prompt with a join prompt as its parent; let's try going back to its parent, which is probably a sequence
            local_parent = text_hint_prompt || initial_prompt_prompt || confirm_correct_prompt || give_up_prompt
            local_parent.sg_parent
          end
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
      if current_top.nil?
        raise RuntimeError, "Reached top of tree and can't find activity in #{current_top.class.to_s}"
      else
        return current_top if current_top.kind_of? Activity
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def is_owner?(user)
    begin
      activity = self.sg_activity
    rescue RuntimeError => e
      message = e.message
      activity = nil
    end
    if activity.nil?
      message = "can't find owner for #{self} (no activity found)"
      logger.debug message
      puts message
      return true
    end
    return activity.is_owner?(user)
  end

  def create_permitted?
    logger.debug "Checking create permissions for #{self}"
    if acting_user.signed_up?
      # return true
      self.is_owner?(acting_user)
    end
    return false
  end

  def update_permitted?
    logger.debug "Checking update permissions for #{self}"
    return true if acting_user.administrator?
    return true if self.is_owner?(acting_user)
    return false
  end

  def destroy_permitted?
    logger.debug "Checking destroy permissions for #{self}"
    return true if acting_user.administrator?
    return true if self.is_owner?(acting_user)
    return false
  end

  def view_permitted?(field)
    logger.debug "Checking view permissions for #{self}"
    true
  end

  def edit_permitted?(attribute)
    logger.debug "Checking edit permissions for #{self}"
    return true if acting_user.administrator?
    return self.is_owner?(acting_user)
  end

end