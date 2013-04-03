# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :label_set do
    sequence(:name) { |i| "label_set_#{i}" }
    
    factory :full_label_set do
      name "full_data_set"
      after(:create) do |label_set, evaluator|
        label_set.graph_labels = FactoryGirl.create_list(:graph_label, 3, :label_set => label_set)
      end
      # TODO: Graph panes?
    end
  end
end
