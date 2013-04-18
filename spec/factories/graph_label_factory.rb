# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence (:labeltext) { Faker::Lorem.sentence(5) }

  factory :graph_label do
    text      { generate(:labeltext) }
    x_coord   1
    y_coord   1
  end
end
