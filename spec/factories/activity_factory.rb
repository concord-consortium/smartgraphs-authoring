FactoryGirl.define do
  
  factory :activity do
    # sequence(:name) { |n| "Activity#{n}"}
    name "Activity"
    author_name "Mr Author"
    publication_status 'private'

    factory :public_activity do
      name "Public Activity"
      publication_status 'public'
    end

    factory :private_activity do
      name "Private Activity"
      publication_status 'private'
    end

    factory :activity_with_dataset do
      name "Dataset Activity"
      publication_status 'public'

      after(:create) do |activity, evaluator|
        activity.data_sets = FactoryGirl.create_list(:full_data_set, 1, :activity => activity)
      end
    end

  end
end
