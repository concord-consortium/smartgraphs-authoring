class DropOwnerColumns < ActiveRecord::Migration
  def self.up
    remove_column :annotation_inclusions, :owner_id

    remove_column :prediction_graph_panes, :owner_id

    remove_column :confirm_correct_prompts, :owner_id

    remove_column :pick_a_point_sequences, :owner_id

    remove_column :numeric_sequences, :owner_id

    remove_column :constructed_response_sequences, :owner_id

    remove_column :give_up_prompts, :owner_id

    remove_column :image_panes, :owner_id

    remove_column :initial_prompt_prompts, :owner_id

    remove_column :instruction_sequences, :owner_id

    remove_column :json_activities, :owner_id

    remove_column :multiple_choice_choices, :owner_id

    remove_column :multiple_choice_sequences, :owner_id

    remove_column :multiple_choice_hints, :owner_id

    remove_column :page_panes, :owner_id

    remove_column :pages, :owner_id

    remove_column :page_sequences, :owner_id

    remove_column :point_axis_line_visual_prompts, :owner_id

    remove_column :point_circle_visual_prompts, :owner_id

    remove_column :predefined_graph_panes, :owner_id

    remove_column :range_visual_prompts, :owner_id

    remove_column :sensor_graph_panes, :owner_id

    remove_column :sequence_hints, :owner_id

    remove_column :slope_tool_sequences, :owner_id

    remove_column :table_panes, :owner_id

    remove_column :text_hint_prompts, :owner_id

    remove_column :text_hints, :owner_id

    remove_index :annotation_inclusions, :name => :index_annotation_inclusions_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :prediction_graph_panes, :name => :index_prediction_graph_panes_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :confirm_correct_prompts, :name => :index_confirm_correct_prompts_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :pick_a_point_sequences, :name => :index_pick_a_point_sequences_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :numeric_sequences, :name => :index_numeric_sequences_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :constructed_response_sequences, :name => :index_constructed_response_sequences_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :give_up_prompts, :name => :index_give_up_prompts_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :image_panes, :name => :index_image_panes_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :initial_prompt_prompts, :name => :index_initial_prompt_prompts_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :instruction_sequences, :name => :index_instruction_sequences_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :json_activities, :name => :index_json_activities_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :multiple_choice_choices, :name => :index_multiple_choice_choices_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :multiple_choice_sequences, :name => :index_multiple_choice_sequences_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :multiple_choice_hints, :name => :index_multiple_choice_hints_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :page_panes, :name => :index_page_panes_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :pages, :name => :index_pages_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :page_sequences, :name => :index_page_sequences_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :point_axis_line_visual_prompts, :name => :index_point_axis_line_visual_prompts_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :point_circle_visual_prompts, :name => :index_point_circle_visual_prompts_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :predefined_graph_panes, :name => :index_predefined_graph_panes_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :range_visual_prompts, :name => :index_range_visual_prompts_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :sensor_graph_panes, :name => :index_sensor_graph_panes_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :sequence_hints, :name => :index_sequence_hints_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :slope_tool_sequences, :name => :index_slope_tool_sequences_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :table_panes, :name => :index_table_panes_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :text_hint_prompts, :name => :index_text_hint_prompts_on_owner_id rescue ActiveRecord::StatementInvalid

    remove_index :text_hints, :name => :index_text_hints_on_owner_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :annotation_inclusions, :owner_id, :integer

    add_column :prediction_graph_panes, :owner_id, :integer

    add_column :confirm_correct_prompts, :owner_id, :integer

    add_column :pick_a_point_sequences, :owner_id, :integer

    add_column :numeric_sequences, :owner_id, :integer

    add_column :constructed_response_sequences, :owner_id, :integer

    add_column :give_up_prompts, :owner_id, :integer

    add_column :image_panes, :owner_id, :integer

    add_column :initial_prompt_prompts, :owner_id, :integer

    add_column :instruction_sequences, :owner_id, :integer

    add_column :json_activities, :owner_id, :integer

    add_column :multiple_choice_choices, :owner_id, :integer

    add_column :multiple_choice_sequences, :owner_id, :integer

    add_column :multiple_choice_hints, :owner_id, :integer

    add_column :page_panes, :owner_id, :integer

    add_column :pages, :owner_id, :integer

    add_column :page_sequences, :owner_id, :integer

    add_column :point_axis_line_visual_prompts, :owner_id, :integer

    add_column :point_circle_visual_prompts, :owner_id, :integer

    add_column :predefined_graph_panes, :owner_id, :integer

    add_column :range_visual_prompts, :owner_id, :integer

    add_column :sensor_graph_panes, :owner_id, :integer

    add_column :sequence_hints, :owner_id, :integer

    add_column :slope_tool_sequences, :owner_id, :integer

    add_column :table_panes, :owner_id, :integer

    add_column :text_hint_prompts, :owner_id, :integer

    add_column :text_hints, :owner_id, :integer

    add_index :annotation_inclusions, [:owner_id]

    add_index :prediction_graph_panes, [:owner_id]

    add_index :confirm_correct_prompts, [:owner_id]

    add_index :pick_a_point_sequences, [:owner_id]

    add_index :numeric_sequences, [:owner_id]

    add_index :constructed_response_sequences, [:owner_id]

    add_index :give_up_prompts, [:owner_id]

    add_index :image_panes, [:owner_id]

    add_index :initial_prompt_prompts, [:owner_id]

    add_index :instruction_sequences, [:owner_id]

    add_index :json_activities, [:owner_id]

    add_index :multiple_choice_choices, [:owner_id]

    add_index :multiple_choice_sequences, [:owner_id]

    add_index :multiple_choice_hints, [:owner_id]

    add_index :page_panes, [:owner_id]

    add_index :pages, [:owner_id]

    add_index :page_sequences, [:owner_id]

    add_index :point_axis_line_visual_prompts, [:owner_id]

    add_index :point_circle_visual_prompts, [:owner_id]

    add_index :predefined_graph_panes, [:owner_id]

    add_index :range_visual_prompts, [:owner_id]

    add_index :sensor_graph_panes, [:owner_id]

    add_index :sequence_hints, [:owner_id]

    add_index :slope_tool_sequences, [:owner_id]

    add_index :table_panes, [:owner_id]

    add_index :text_hint_prompts, [:owner_id]

    add_index :text_hints, [:owner_id]
  end
end
