class ActivitiesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  index_action :my_activities
  index_action :all_activities

  def index
      load_activities(Activity.publication_status_is('public'))
      hobo_index @activities do |expects|
        expects.json { render :json => @activities.to_json }
        expects.csv { render :text => @activities.weigh_anchor.maroon } # Uses csv_pirate to create a CSV serialization
        expects.html { hobo_index @activities }
      end
  end

  def show
    hobo_show do |format|
      format.json {
        render :text => @activity.runtime_json
      }
      format.runtime_json {
        render :text => @activity.json
      }
      format.yaml {
        render :text => @activity.to_hash.to_yaml
      }
      format.html {}
    end
  end

  def json_text
    JSON.pretty_generate(Activity.find(params[:id]).runtime_json)
  end

  show_action :author_preview do
    hobo_show do |format|
      format.json {
        render :text => @activity.runtime_json
      }
      format.html {
        render :text => Activity.find(params[:id]).author_runtime_html
        cache_page(response.body, request.path)
      }
    end
  end

  show_action :student_preview do
    hobo_show do |format|
      format.json {
        render :text => @activity.runtime_json
      }
      format.html {
        render :text => Activity.find(params[:id]).student_runtime_html
        cache_page(response.body, request.path)
      }
    end
  end

  show_action :copy do
    activity_id = params[:id]
    original = Activity.find(activity_id)
    copy = original.copy_activity(current_user)
    copy.name = "copy of #{copy.name}"
    copy.save!
    redirect_to activity_url(copy)
  end

  index_action :my_activities do
    load_activities(Activity.owner_is(current_user))
    hobo_index @activities
  end

  index_action :all_activities do
    load_activities(Activity)
    hobo_index @activities do |expects|
      expects.csv { render :text => Activity.weigh_anchor.maroon } # Uses csv_pirate to create a CSV serialization
      expects.html { hobo_index @activities }
    end
  end


  #####################################################
  private
  #####################################################

  def load_activities(activities)
    @activity_filter = ActivityFilter.new(activities,params)
    @activities = @activity_filter.activities
  end

end
