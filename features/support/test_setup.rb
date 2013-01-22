require File.dirname(__FILE__) + '/env.rb'

include Capybara::DSL

# Login using the URL that's only exposed in development and test mode
 def do_login(name='admin', is_admin=true)
  u =  user_create(name, is_admin)
  visit "/dev/set_current_user?login=#{u.email_address}"
  # raise "do_login: Error login of #{name} with admin = #{is_admin}" if page.status_code != 200
end

# Create a user in the DB. Also, caches the user in a global cache
# setup in the seeds.rb.
def user_create(name='admin', is_admin=true)
  key = "#{name}:#{is_admin}"
  UserCache.instance[key] ||= User.find_or_create_by_name(name) do |u|
    u.email_address = "#{u.name}@concord.org"
    u.password = u.password_confirmation = "#{u.name}pAsS"
    u.state = 'active'
    u.administrator = is_admin
  end
end

# Login by filling out the login page
def do_login_ui(name='admin', is_admin=true)
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
