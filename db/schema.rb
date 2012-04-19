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

ActiveRecord::Schema.define(:version => 20120419181550) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author_name"
  end

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

  create_table "confirm_correct_prompts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pick_a_point_sequence_id"
    t.integer  "prompt_id"
    t.string   "prompt_type"
    t.integer  "numeric_sequence_id"
  end

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

  create_table "give_up_prompts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pick_a_point_sequence_id"
    t.integer  "prompt_id"
    t.string   "prompt_type"
    t.integer  "numeric_sequence_id"
  end

  add_index "give_up_prompts", ["numeric_sequence_id"], :name => "index_give_up_prompts_on_numeric_sequence_id"
  add_index "give_up_prompts", ["pick_a_point_sequence_id"], :name => "index_give_up_prompts_on_pick_a_point_sequence_id"
  add_index "give_up_prompts", ["prompt_type", "prompt_id"], :name => "index_give_up_prompts"

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
  end

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
  end

  create_table "numeric_sequences", :force => true do |t|
    t.string   "title"
    t.text     "initial_prompt"
    t.text     "give_up"
    t.text     "confirm_correct"
    t.float    "correct_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "tolerance",       :default => 0.1
  end

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
  end

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
    t.string   "slope_variable_name"
    t.float    "x_min",               :default => 0.0
    t.float    "y_min",               :default => 0.0
    t.float    "x_max",               :default => 10.0
    t.float    "y_max",               :default => 10.0
    t.float    "tolerance",           :default => 0.1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "case_type",           :default => "case_a"
    t.string   "point_constraints",   :default => "any"
  end

  create_table "table_panes", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
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
