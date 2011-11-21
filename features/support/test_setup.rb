require File.dirname(__FILE__) + '/env.rb'

# disable resetting sessions between scenarios
module Capybara
  class << self
    def reset_sessions!
      # no-op
    end
  end
end

# log in now, since we're only running tests with one user: an admin
u = User.find_or_create_by_name('admin') do |u|
  u.email_address = 'admin@concord.org'
  u.password = u.password_confirmation = 'Adminpass'
  u.state = 'active'
  u.administrator = true
end
u.save!

include Capybara::DSL

visit '/login'
fill_in "login", :with => 'admin@concord.org'
fill_in "password", :with => 'Adminpass'
click_button 'Login'
