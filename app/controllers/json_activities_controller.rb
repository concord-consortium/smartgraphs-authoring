require 'erb'

class JsonActivitiesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def preview
    File.open "#{Rails.root}/public/static/smartgraphs/en/817dd27df90f8bee344663d0bd63f4993512bbd2/index.html" do |file|
      template = ERB.new file.read
      authored_activity_json = JsonActivity.find(params[:id]).json
      render :text => template.result(binding)
    end
  end
end
