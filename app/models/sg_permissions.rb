# encoding: UTF-8

module SgPermissions
  module ClassMethods
    # sg_parent :activity
    # sg_parent :any_sequence
    def sg_parent(symbol)
      if (symbol == :any_sequence)
        define_method "sg_parent" do
          symbols = %w[
            numeric_sequence
            pick_a_point_sequence
            multiple_choice_sequence
            best_fit_sequence
            slope_tool_sequence
            constructed_response_sequence
            instruction_sequence
            text_hint_prompt
            initial_prompt_prompt
            confirm_correct_prompt
            give_up_prompt
          ].map { |s| s.strip.to_sym }
          found = symbols.detect do |sym|
            self.respond_to?(sym) && self.send(sym)
          end
          if found
            return self.send found
          else
            Rails.logger.error("could not find parent for #{self}")
          end
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
    last_top = current_top
    while (current_top.respond_to? :sg_parent)
      current_top = current_top.send(:sg_parent)
      if current_top.nil?
        return nil
      else
        return current_top if current_top.kind_of? Activity
      end
      last_top = current_top
    end
  end

  def mark_activity_dirty
    # this is method can slow things down in tests.
    return if ENV['SKIP_ACTIVITY_MARKING'] 
    activity = self.sg_activity
    if activity
      activity.reload
      activity.validate_runtime_json unless activity.prevent_conversion?
    else
      logger.info("No activity found for #{self}")
    end
    return true # We don't prevent saving
  end

  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      after_update :mark_activity_dirty
      after_create :mark_activity_dirty
      after_destroy :mark_activity_dirty
    end
  end

  def is_owner?(user)
    activity = self.sg_activity
    if activity.nil?
      message = "can't find owner for #{self} (no activity found)"
      logger.debug message
      return true
    end
    return activity.is_owner?(user)
  end

  def create_permitted?
    logger.debug "Checking create permissions for #{self}"
    if acting_user.signed_up?
      return true
      # self.is_owner?(acting_user)
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
