class ApplicationController < ActionController::Base
  protect_from_forgery

  class << self

    def polymorphic_auto_actions_for(owner_association, actions)
      auto_actions_for owner_association, actions

      define_method "new_for_#{owner_association}" do
        owner, association = find_owner_and_association(owner_association)
        new_record = association.user_new(current_user)
        new_record.send "#{owner_association}=", owner
        hobo_new_for owner_association, new_record
      end

      define_method "create_for_#{owner_association}" do
        owner, association = find_owner_and_association(owner_association)
        attributes = attribute_parameters || {}
        attributes[owner_association] = owner
        hobo_create_for owner_association, :attributes => attributes
      end
    end
  end
end
