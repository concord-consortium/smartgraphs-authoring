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
        activity.pages = FactoryGirl.create_list(:page, 3, :activity => activity)
      end
    end

    factory :activity_with_labelset do
      name "Labelset Activity"
      publication_status 'public'

      after(:create) do |activity, evaluator|
        activity.label_sets = FactoryGirl.create_list(:full_label_set, 1, :activity => activity)
        activity.pages = FactoryGirl.create_list(:page, 3, :activity => activity)
      end
    end

    factory :activity_with_page do
      name "Activity With Page"

      after(:create) do |activity, evaluator|
        activity.pages = FactoryGirl.create_list(:page, 1, :activity => activity)
      end

      factory :activity_with_predefined_graph_pane do
        name "Activity With PredefinedGraphPane"

        after(:create) do |activity, evaluator|
          page = activity.pages.first
          page.predefined_graph_panes = FactoryGirl.create_list(:predefined_graph_pane, 1, :page => page)
        end

        factory :activity_with_animated_graph_pane do
          name "Activity With Animated PredefinedGraphPane"

          after(:create) do |activity, evaluator|
            activity.animations = FactoryGirl.create_list(:animation, 1, :activity => activity)
            pane = activity.pages.first.predefined_graph_panes.first
            pane.animation = activity.animations.first
          end
        end
      end
    end
  end

end