class ActivitiesController < ApplicationController

  hobo_model_controller

  auto_actions :all

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

  show_action :preview do
    hobo_show do |format|
      sg_runtime_json = Converter.new().convert(Activity.find(params[:id]).to_hash.to_json)
      format.json {
        render :text => JSON.pretty_generate(JSON.parse(sg_runtime_json))
      }
      format.html {
        File.open "#{Rails.root}/public/static/smartgraphs/en/4b16f9339305b3d2916641c6012a3a41df4c0874/index.html" do |file|
          # the 'authored_activity_json' variable name is used in the template so can't be changed without
          # changing the template
          authored_activity_json = sg_runtime_json
          template = ERB.new file.read
          render :text => template.result(binding)
        end
      }
    end
  end

end
