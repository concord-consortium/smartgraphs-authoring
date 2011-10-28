require 'erb'

class JsonActivitiesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def preview
    File.open "#{Rails.root}/public/static/smartgraphs/en/82b404e9816653aae3437852c272301c88eb986a/index.html" do |file|
      template = ERB.new file.read
      authored_activity_json = JsonActivity.find(params[:id]).json
      render :text => template.result(binding)
    end
  end
end
