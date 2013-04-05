# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130405175743) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author_name"
    t.integer  "owner_id"
    t.string   "publication_status", :default => "private"
  end

  add_index "activities", ["owner_id"], :name => "index_activities_on_owner_id"

  create_table "activity_grade_levels", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_id"
    t.integer  "grade_level_id"
  end

  add_index "activity_grade_levels", ["activity_id"], :name => "index_activity_grade_levels_on_activity_id"
  add_index "activity_grade_levels", ["grade_level_id"], :name => "index_activity_grade_levels_on_grade_level_id"

  create_table "activity_subject_areas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_id"
    t.integer  "subject_area_id"
  end

  add_index "activity_subject_areas", ["activity_id"], :name => "index_activity_subject_areas_on_activity_id"
  add_index "activity_subject_areas", ["subject_area_id"], :name => "index_activity_subject_areas_on_subject_area_id"

  create_table "animations", :force => true do |t|
    t.string   "name"
    t.float    "y_min"
    t.float    "y_max"
    t.text     "marked_coordinates"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_id"
    t.integer  "data_set_id"
  end

  add_index "animations", ["activity_id"], :name => "index_animations_on_activity_id"
  add_index "animations", ["data_set_id"], :name => "index_animations_on_data_set_id"

  create_table "annotation_inclusions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "included_graph_id"
    t.integer  "including_graph_id"
    t.string   "including_graph_type"
    t.integer  "position"
  end

  add_index "annotation_inclusions", ["included_graph_id"], :name => "included_graph_idx"
  add_index "annotation_inclusions", ["including_graph_type", "including_graph_id"], :name => "including_graph_idx"

  create_table "best_fit_sequences", :force => true do |t|
    t.float    "correct_tolerance",   :default => 0.1
    t.float    "close_tolerance",     :default => 0.2
    t.integer  "max_attempts",        :default => 4
    t.text     "initial_prompt"
    t.text     "incorrect_prompt"
    t.text     "close_prompt"
    t.text     "confirm_correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "data_set_id"
    t.integer  "learner_data_set_id"
    t.text     "give_up"
  end

  add_index "best_fit_sequences", ["data_set_id"], :name => "index_best_fit_sequences_on_data_set_id"
  add_index "best_fit_sequences", ["learner_data_set_id"], :name => "index_best_fit_sequences_on_learner_data_set_id"

  create_table "confirm_correct_prompts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pick_a_point_sequence_id"
    t.integer  "prompt_id"
    t.string   "prompt_type"
    t.integer  "numeric_sequence_id"
    t.integer  "multiple_choice_sequence_id"
  end

  add_index "confirm_correct_prompts", ["multiple_choice_sequence_id"], :name => "index_confirm_correct_prompts_on_multiple_choice_sequence_id"
  add_index "confirm_correct_prompts", ["numeric_sequence_id"], :name => "index_confirm_correct_prompts_on_numeric_sequence_id"
  add_index "confirm_correct_prompts", ["pick_a_point_sequence_id"], :name => "index_confirm_correct_prompts_on_pick_a_point_sequence_id"
  add_index "confirm_correct_prompts", ["prompt_type", "prompt_id"], :name => "index_confirm_correct_prompts"

  create_table "constructed_response_sequences", :force => true do |t|
    t.string   "title"
    t.text     "initial_prompt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "initial_content"
  end

  create_table "data_set_predefined_graphs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "data_set_id"
    t.integer  "predefined_graph_pane_id"
    t.boolean  "in_legend",                :default => false
  end

  add_index "data_set_predefined_graphs", ["data_set_id"], :name => "index_data_set_predefined_graphs_on_data_set_id"
  add_index "data_set_predefined_graphs", ["predefined_graph_pane_id"], :name => "index_data_set_predefined_graphs_on_predefined_graph_pane_id"

  create_table "data_set_prediction_graphs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "data_set_id"
    t.integer  "prediction_graph_pane_id"
    t.boolean  "in_legend",                :default => false
  end

  add_index "data_set_prediction_graphs", ["data_set_id"], :name => "index_data_set_prediction_graphs_on_data_set_id"
  add_index "data_set_prediction_graphs", ["prediction_graph_pane_id"], :name => "index_data_set_prediction_graphs_on_prediction_graph_pane_id"

  create_table "data_set_sensor_graphs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "data_set_id"
    t.integer  "sensor_graph_pane_id"
    t.boolean  "in_legend",            :default => false
  end

  add_index "data_set_sensor_graphs", ["data_set_id"], :name => "index_data_set_sensor_graphs_on_data_set_id"
  add_index "data_set_sensor_graphs", ["sensor_graph_pane_id"], :name => "index_data_set_sensor_graphs_on_sensor_graph_pane_id"

  create_table "data_sets", :force => true do |t|
    t.string   "name"
    t.float    "y_precision",        :default => 0.1
    t.float    "x_precision",        :default => 0.1
    t.float    "line_snap_distance", :default => 0.1
    t.string   "expression",         :default => ""
    t.string   "line_type",          :default => "none"
    t.string   "point_type",         :default => "dot"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "y_unit_id"
    t.integer  "x_unit_id"
    t.integer  "activity_id"
  end

  add_index "data_sets", ["activity_id"], :name => "index_data_sets_on_activity_id"
  add_index "data_sets", ["x_unit_id"], :name => "index_data_sets_on_x_unit_id"
  add_index "data_sets", ["y_unit_id"], :name => "index_data_sets_on_y_unit_id"

  create_table "give_up_prompts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pick_a_point_sequence_id"
    t.integer  "prompt_id"
    t.string   "prompt_type"
    t.integer  "numeric_sequence_id"
    t.integer  "multiple_choice_sequence_id"
  end

  add_index "give_up_prompts", ["multiple_choice_sequence_id"], :name => "index_give_up_prompts_on_multiple_choice_sequence_id"
  add_index "give_up_prompts", ["numeric_sequence_id"], :name => "index_give_up_prompts_on_numeric_sequence_id"
  add_index "give_up_prompts", ["pick_a_point_sequence_id"], :name => "index_give_up_prompts_on_pick_a_point_sequence_id"
  add_index "give_up_prompts", ["prompt_type", "prompt_id"], :name => "index_give_up_prompts"

  create_table "grade_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graph_labels", :force => true do |t|
    t.integer  "label_set_id"
    t.string   "text"
    t.float    "x_coord"
    t.float    "y_coord"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "graph_labels", ["label_set_id"], :name => "index_graph_labels_on_label_set_id"

  create_table "image_panes", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "license"
    t.string   "attribution"
  end

  create_table "initial_prompt_prompts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pick_a_point_sequence_id"
    t.integer  "prompt_id"
    t.string   "prompt_type"
    t.integer  "numeric_sequence_id"
    t.integer  "multiple_choice_sequence_id"
  end

  add_index "initial_prompt_prompts", ["multiple_choice_sequence_id"], :name => "index_initial_prompt_prompts_on_multiple_choice_sequence_id"
  add_index "initial_prompt_prompts", ["numeric_sequence_id"], :name => "index_initial_prompt_prompts_on_numeric_sequence_id"
  add_index "initial_prompt_prompts", ["pick_a_point_sequence_id"], :name => "index_initial_prompt_prompts_on_pick_a_point_sequence_id"
  add_index "initial_prompt_prompts", ["prompt_type", "prompt_id"], :name => "index_initial_prompt_prompts"

  create_table "instruction_sequences", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text"
  end

  create_table "json_activities", :force => true do |t|
    t.string   "name"
    t.text     "json"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "label_sequences", :force => true do |t|
    t.string   "title",        :default => "New label sequence"
    t.text     "text"
    t.integer  "label_count",  :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "label_set_id"
  end

  add_index "label_sequences", ["label_set_id"], :name => "index_label_sequences_on_label_set_id"

  create_table "label_set_predefined_graphs", :force => true do |t|
    t.integer  "label_set_id"
    t.integer  "predefined_graph_pane_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "label_set_predefined_graphs", ["label_set_id"], :name => "index_label_set_predefined_graphs_on_label_set_id"
  add_index "label_set_predefined_graphs", ["predefined_graph_pane_id"], :name => "index_label_set_predefined_graphs_on_predefined_graph_pane_id"

  create_table "label_sets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_id"
    t.boolean  "is_for_users", :default => false
  end

  add_index "label_sets", ["activity_id"], :name => "index_label_sets_on_activity_id"

  create_table "line_construction_sequences", :force => true do |t|
    t.string   "title",                 :default => "new line construction"
    t.float    "slope",                 :default => 1.0
    t.float    "slope_tolerance",       :default => 0.1
    t.float    "y_intercept",           :default => 0.0
    t.float    "y_intercept_tolerance", :default => 0.1
    t.text     "initial_prompt"
    t.text     "confirm_correct"
    t.text     "slope_incorrect"
    t.text     "y_intercept_incorrect"
    t.text     "all_incorrect"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "data_set_id"
    t.integer  "max_attempts",          :default => 3
    t.text     "give_up"
  end

  add_index "line_construction_sequences", ["data_set_id"], :name => "index_line_construction_sequences_on_data_set_id"

  create_table "multiple_choice_choices", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "multiple_choice_sequence_id"
    t.boolean  "correct"
    t.text     "feedback"
  end

  add_index "multiple_choice_choices", ["multiple_choice_sequence_id"], :name => "multiple_choice_sequence_multiple_choice_choice_index"

  create_table "multiple_choice_hints", :force => true do |t|
    t.string   "name"
    t.text     "hint_text"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "multiple_choice_sequence_id"
  end

  add_index "multiple_choice_hints", ["multiple_choice_sequence_id"], :name => "multiple_choice_sequence_multiple_choice_hint_index"

  create_table "multiple_choice_sequences", :force => true do |t|
    t.text     "initial_prompt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "give_up"
    t.text     "confirm_correct"
    t.boolean  "use_sequential_feedback", :default => true
    t.integer  "data_set_id"
  end

  add_index "multiple_choice_sequences", ["data_set_id"], :name => "index_multiple_choice_sequences_on_data_set_id"

  create_table "numeric_sequences", :force => true do |t|
    t.string   "title"
    t.text     "initial_prompt"
    t.text     "give_up"
    t.text     "confirm_correct"
    t.float    "correct_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "tolerance",       :default => 0.01
    t.integer  "data_set_id"
  end

  add_index "numeric_sequences", ["data_set_id"], :name => "index_numeric_sequences_on_data_set_id"

  create_table "page_panes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_id"
    t.integer  "pane_id"
    t.string   "pane_type"
    t.integer  "position"
  end

  add_index "page_panes", ["page_id"], :name => "index_page_panes_on_page_id"
  add_index "page_panes", ["pane_type", "pane_id"], :name => "index_page_panes_on_pane_type_and_pane_id"

  create_table "page_sequences", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_id"
    t.integer  "sequence_id"
    t.string   "sequence_type"
  end

  add_index "page_sequences", ["page_id"], :name => "index_page_sequences_on_page_id"
  add_index "page_sequences", ["sequence_type", "sequence_id"], :name => "index_sequences"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_id"
    t.integer  "position"
  end

  add_index "pages", ["activity_id"], :name => "index_pages_on_activity_id"

  create_table "pick_a_point_sequences", :force => true do |t|
    t.string   "title"
    t.text     "initial_prompt"
    t.float    "correct_answer_x"
    t.float    "correct_answer_y"
    t.text     "give_up"
    t.text     "confirm_correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "correct_answer_x_min"
    t.float    "correct_answer_y_min"
    t.float    "correct_answer_x_max"
    t.float    "correct_answer_y_max"
    t.integer  "data_set_id"
  end

  add_index "pick_a_point_sequences", ["data_set_id"], :name => "index_pick_a_point_sequences_on_data_set_id"

  create_table "point_axis_line_visual_prompts", :force => true do |t|
    t.string   "name"
    t.float    "point_x"
    t.float    "point_y"
    t.string   "color"
    t.string   "axis"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "point_circle_visual_prompts", :force => true do |t|
    t.string   "name"
    t.float    "point_x"
    t.float    "point_y"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "predefined_graph_panes", :force => true do |t|
    t.string   "title"
    t.string   "y_label"
    t.float    "y_min"
    t.float    "y_max"
    t.float    "y_ticks"
    t.string   "x_label"
    t.float    "x_min"
    t.float    "x_max"
    t.float    "x_ticks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "y_unit_id"
    t.integer  "x_unit_id"
    t.text     "data"
    t.float    "y_precision",          :default => 0.1
    t.float    "x_precision",          :default => 0.1
    t.string   "expression",           :default => ""
    t.float    "line_snap_distance",   :default => 0.1
    t.string   "line_type",            :default => "none"
    t.string   "point_type",           :default => "dot"
    t.boolean  "show_cross_hairs",     :default => false
    t.boolean  "show_graph_grid",      :default => false
    t.boolean  "show_tool_tip_coords", :default => false
  end

  add_index "predefined_graph_panes", ["x_unit_id"], :name => "index_predefined_graph_panes_on_x_unit_id"
  add_index "predefined_graph_panes", ["y_unit_id"], :name => "index_predefined_graph_panes_on_y_unit_id"

  create_table "prediction_graph_panes", :force => true do |t|
    t.string   "title"
    t.string   "y_label"
    t.float    "y_min"
    t.float    "y_max"
    t.float    "y_ticks"
    t.string   "x_label"
    t.float    "x_min"
    t.float    "x_max"
    t.float    "x_ticks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "y_unit_id"
    t.integer  "x_unit_id"
    t.string   "prediction_type"
    t.float    "y_precision",          :default => 0.1
    t.float    "x_precision",          :default => 0.1
    t.boolean  "show_cross_hairs",     :default => false
    t.boolean  "show_graph_grid",      :default => false
    t.boolean  "show_tool_tip_coords", :default => false
  end

  add_index "prediction_graph_panes", ["x_unit_id"], :name => "index_prediction_graph_panes_on_x_unit_id"
  add_index "prediction_graph_panes", ["y_unit_id"], :name => "index_prediction_graph_panes_on_y_unit_id"

  create_table "range_visual_prompts", :force => true do |t|
    t.string   "name"
    t.float    "x_min"
    t.float    "x_max"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sensor_graph_panes", :force => true do |t|
    t.string   "title"
    t.string   "y_label"
    t.float    "y_min"
    t.float    "y_max"
    t.float    "y_ticks"
    t.string   "x_label"
    t.float    "x_min"
    t.float    "x_max"
    t.float    "x_ticks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "y_unit_id"
    t.integer  "x_unit_id"
    t.boolean  "show_cross_hairs",     :default => false
    t.boolean  "show_graph_grid",      :default => false
    t.boolean  "show_tool_tip_coords", :default => false
  end

  add_index "sensor_graph_panes", ["x_unit_id"], :name => "index_sensor_graph_panes_on_x_unit_id"
  add_index "sensor_graph_panes", ["y_unit_id"], :name => "index_sensor_graph_panes_on_y_unit_id"

  create_table "sequence_hints", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pick_a_point_sequence_id"
    t.integer  "hint_id"
    t.string   "hint_type"
    t.integer  "position"
    t.integer  "numeric_sequence_id"
  end

  add_index "sequence_hints", ["hint_type", "hint_id"], :name => "index_hints"
  add_index "sequence_hints", ["numeric_sequence_id"], :name => "index_sequence_hints_on_numeric_sequence_id"
  add_index "sequence_hints", ["pick_a_point_sequence_id"], :name => "index_sequence_hints_on_pick_a_point_sequence_id"

  create_table "slope_tool_sequences", :force => true do |t|
    t.text     "first_question"
    t.string   "slope_variable_name", :default => "slope"
    t.float    "x_min",               :default => 0.0
    t.float    "y_min",               :default => 0.0
    t.float    "x_max",               :default => 10.0
    t.float    "y_max",               :default => 10.0
    t.float    "tolerance",           :default => 0.1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "case_type",           :default => "case_a"
    t.string   "point_constraints",   :default => "any"
    t.integer  "data_set_id"
  end

  add_index "slope_tool_sequences", ["data_set_id"], :name => "index_slope_tool_sequences_on_data_set_id"

  create_table "subject_areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "table_panes", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "x_label"
    t.string   "y_label"
  end

  create_table "text_hint_prompts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "text_hint_id"
    t.integer  "prompt_id"
    t.string   "prompt_type"
  end

  add_index "text_hint_prompts", ["prompt_type", "prompt_id"], :name => "index_prompts"
  add_index "text_hint_prompts", ["text_hint_id"], :name => "index_text_hint_prompts_on_text_hint_id"

  create_table "text_hints", :force => true do |t|
    t.string   "name"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "inactive"
    t.datetime "key_timestamp"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

end
