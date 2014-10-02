class ApplicationController < ActionController::Base
  protect_from_forgery


  before_filter :set_locale

  def set_locale
    I18n.locale = extract_locale_from_accept_language_header
  end

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

  def get_included_graphs(included_graphs_params)
    # now process any included graphs
    included = []
    if included_graphs_params
      included_graphs_params.each do |text_id|
        if text_id =~ /^@(.*?)\|(\d+)/
          puts "#{$1}.constantize.find(#{$2})"
          graph = $1.constantize.find($2)
          included << graph
        end
      end
    end
    return included
  end

  private
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

end
