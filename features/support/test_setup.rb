require File.dirname(__FILE__) + '/env.rb'

include Capybara::DSL

def do_login
  u = User.find_or_create_by_name('admin') do |u|
    u.email_address = 'admin@concord.org'
    u.password = u.password_confirmation = 'Adminpass'
    u.state = 'active'
    u.administrator = true
  end
  u.save!

  visit '/logout'
  visit '/login'
  fill_in "login", :with => 'admin@concord.org'
  fill_in "password", :with => 'Adminpass'
  click_button 'Login'
end

# log in now, since we're only running tests with one user: an admin

Before do
  do_login
end
