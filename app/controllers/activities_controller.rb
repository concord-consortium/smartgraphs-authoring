class ActivitiesController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  def show
    hobo_show do |format|
      format.json {
        render :text => @activity.to_hash.to_json
      }
      format.yaml {
        render :text => @activity.to_hash.to_yaml
      }
      format.html {}
    end
  end

  def preview
    # TODO:
    # This works locally, but on the server it dies with
    # 
    # $ tail -f /web/portal/shared/log/production.log 
    # 
    # Completed 500 Internal Server Error in 23ms
    # Errno::EPIPE (Broken pipe):
    #   app/models/converter.rb:17:in `write'
    #   app/models/converter.rb:17:in `puts'
    #   app/models/converter.rb:17:in `block in convert'
    #   app/models/converter.rb:16:in `popen'
    #   app/models/converter.rb:16:in `convert'
    #   app/controllers/activities_controller.rb:20:in `preview'
    #   
    #   if you specify Converter.new("/bin/cat") then there is no pipe error,
    #   but the json is obviously busted.  You can use:
    #
    #   authored_activity_json = Converter.new("/bin/cat").convert("{}")
    #
    # and that will work for you...
    #
    authored_activity_json = Converter.new("#{Rails.root}/smartgraphs-generator/bin/sg-convert").convert(Activity.find(params[:id]).to_hash.to_json)
    File.open "#{Rails.root}/public/static/smartgraphs/en/5a2301d099b8d537c51560051dd2bc99eb4b582f/index.html" do |file|
      template = ERB.new file.read
      render :text => template.result(binding)
    end
  end

end
