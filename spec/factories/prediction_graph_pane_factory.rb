FactoryGirl.define do
  factory :prediction_graph_pane do
    sequence(:title) { |i| "prediction_graph_pane_#{i}" }

    y_label "y label"
    y_min 0.0
    y_max 10.0
    y_ticks 10

    x_label "x label"
    x_min 0.0
    x_max 10.0
    x_ticks 10
  end
end
