# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# create 10 users named, "user_1" ... "user_9"
1..10.times do |i|
  u = User.find_or_create_by_name("user_#{i}") do |u|
    u.email_address = "#{u.name}@example.com"
    u.password = u.password_confirmation = "#{u.name}pAsS"
    u.state = 'active'
    u.administrator = false
  end
  UserCache.instance["user_#{i}:false"] = u
end

# create an admin
UserCache.instance["admin:true"] = User.find_or_create_by_name("admin") do |u|
  u.email_address = "#{u.name}@concord.org"
  u.password = u.password_confirmation = "#{u.name}pAsS"
  u.state = 'active'
  u.administrator = true
end
