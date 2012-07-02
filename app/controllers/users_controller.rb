class UsersController < ApplicationController

  hobo_user_controller

  auto_actions :all, :except => [ :index, :new, :create ]

  # Normally, users should be created via the user lifecycle, except
  #  for the initial user created via the form on the front screen on
  #  first run.  This method creates the initial user.
  def create
    hobo_create do
      if valid?
        self.current_user = this
        flash[:notice] = t("hobo.messages.you_are_site_admin", :default=>"You are now the site administrator")
        redirect_to home_page
      end
    end
  end

  def hobo_do_signup(&b)
    do_creator_action(:signup) do
      if valid?
        success = ht(
          :"#{model.to_s.underscore}.messages.signup.success", 
          :default=>["Thanks for signing up!"]
        )
        must_activate = ht(
          :"#{model.to_s.underscore}.messages.signup.must_activate",
          :default=>["You must activate your account before you can log in. Please check your email."]
        )
        flash[:notice]  = "<p>#{success}</p><p>#{must_activate}</p>".html_safe
      end
      response_block(&b) or if valid?
        self.current_user = this if this.account_active?
        respond_to do |wants|
          wants.html { redirect_back_or_default(home_page) }
          wants.js { hobo_ajax_response }
        end
      end
    end
  end
  

end
