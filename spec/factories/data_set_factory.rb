FactoryGirl.define do
  factory :data_set do
    #sequence(:name) { |i| "#{self.class.name.underscore}_#{i}" }
    sequence(:name) { |i| "data_set_#{i}" }
    y_precision 0.1
    x_precision 0.1
    line_snap_distance 0.1
    expression ""
    line_type "none"
    point_type "dot"
    data ""
    
    factory :full_data_set do
      name "full_data_set"
      after(:create) do |data_set, evaluator|
        data_set.predefined_graph_panes = FactoryGirl.create_list(:predefined_graph_pane, 1)
      end
      after(:create) do |data_set, evaluator|
        data_set.sensor_graph_panes = FactoryGirl.create_list(:sensor_graph_pane, 1)
      end

      after(:create) do |data_set, evaluator|
        data_set.prediction_graph_panes = FactoryGirl.create_list(:prediction_graph_pane, 1)
      end
    end
  end
end
