class ActivitiesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  index_action :my_activities

  def show
    hobo_show do |format|
      format.json {
        render :text => JSON.pretty_generate(@activity.to_hash)
      }
      format.yaml {
        render :text => @activity.to_hash.to_yaml
      }
      format.html {}
    end
  end
  
  def template_filename
    "#{Rails.root}/public/smartgraphs-runtime.html"
  end
  
  def sg_runtime_json
    Converter.new().convert(Activity.find(params[:id]).to_hash.to_json)
  end
  
  def json_text
    JSON.pretty_generate(JSON.parse(sg_runtime_json))
  end
  
  def templated_json(fname, b)
    template = ERB.new File.open(fname).read
    template.result b
  end 
  
  show_action :author_preview do
    hobo_show do |format|
      format.json {
        render :text => json_text
      }
      format.html {
        authored_activity_json = sg_runtime_json
        show_outline = true
        show_edit_button = true
        render :text => templated_json(template_filename, binding)
      }
    end
  end
  
  show_action :student_preview do
    hobo_show do |format|
      format.json {
        render :text => json_text
      }
      format.html {
        authored_activity_json = sg_runtime_json
        show_outline = false
        show_edit_button = false
        render :text => templated_json(template_filename, binding)
      }
    end
  end

  show_action :copy do
    activity_id = params[:id]
    original = Activity.find(activity_id)
    copy = original.copy_activity(current_user)
    copy.name = "copy of #{copy.name}"
    copy.save
    redirect_to activity_url(copy)
  end

  index_action :my_activities do
    @activities = Activity.where(["owner_id = ?", current_user.id]).paginate(:page => params[:page])
    render :index
  end
end
