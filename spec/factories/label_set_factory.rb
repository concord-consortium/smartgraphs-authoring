# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :label_set do
    sequence(:name) { |i| "label_set_#{i}" }
    
    factory :full_label_set do
      name "full_data_set"
      # TODO: Graph panes?
    end
  end
end
