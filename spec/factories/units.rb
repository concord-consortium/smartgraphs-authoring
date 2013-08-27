# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence (:name) { Faker::Lorem.word }
  factory :unit, :class => Unit do
    name  { generate(:name) }
    abbreviation { generate(:name) }
  end
end
