# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :animation_pane do
    after(:create) do |pane, evaluator|
      pane.animation = FactoryGirl.create(:animation)
    end
  end

  factory :activity_with_animation_pane, :parent => :activity_with_animation do
    after(:create) do |activity, evaluator|
      activity.pages = FactoryGirl.create_list(:page, 1, :activity => activity)
      page = activity.pages.first
      animation = activity.animations.first
      page.animation_panes = FactoryGirl.create_list(:animation_pane, 1, :page => page, :animation => animation)
    end
  end

end
