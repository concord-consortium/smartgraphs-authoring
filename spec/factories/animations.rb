# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :animation do
    sequence(:name) { |i| "animation_#{i}" }
    y_min 0
    y_max 10

    factory :animation_with_marked_coordinates do
      after(:create) do |animation, evaluator|
        animation.animation_marked_coordinates = FactoryGirl.create_list(:animation_marked_coordinate, 2, :animation => animation)
      end
    end
  end

  factory :animation_marked_coordinate do
    coordinate { rand() * 10 }
  end

	factory :activity_with_animation, :parent => :activity_with_dataset do
	  name "Activity With Animation"

	  after(:create) do |activity, evaluator|
      activity.animations = FactoryGirl.create_list(:animation_with_marked_coordinates, 1, :activity => activity, :data_set => activity.data_sets.first)
	  end
	end
end
