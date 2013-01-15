FactoryGirl.define do

  sequence :user_name do |n|
    "person#{n}"
  end

  factory :user do
    name user_name
    email_address { |u| u.name+"@example.com"}
    administrator false
    state 'active'
    password 'password1234'
    password_confirmation 'password1234'

    factory :admin do
      name "admin"
      email_address "admin@concord.org"
      administrator true
      state 'active'      
      password 'admin1234'
      password_confirmation 'admin1234'
    end

    %w{ moe larry curly}.each do |n|
      factory n.to_sym do
        name n
        email_address "#{n}@concord.org"
      end
    end
    
  end
end
