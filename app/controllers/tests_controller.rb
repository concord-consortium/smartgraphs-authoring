class TestsController < ApplicationController
  def locale
    render json: {local: I18n.locale }
  end
end
