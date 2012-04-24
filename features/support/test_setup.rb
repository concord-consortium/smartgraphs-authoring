require File.dirname(__FILE__) + '/env.rb'

include Capybara::DSL

def do_login(name='admin', is_admin=true)
  email = "#{name}@concord.org"
  pass  = "#{name}pAsS"
  u = User.find_or_create_by_name(name) do |u|
    u.email_address = email
    u.password = u.password_confirmation = pass
    u.state = 'active'
    u.administrator = is_admin
  end
  u.save!

  visit '/logout'
  visit '/login'
  fill_in "login", :with => email
  fill_in "password", :with => pass
  click_button 'Login'
end

# log in now, since we're only running tests with one user: an admin
#
# Before do
#   do_login
# end
