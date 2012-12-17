module ApplicationHelper

  def activity_for(something)
    binding.pry
    if params[:activity_id]
      @activity_context = Activity.find(params[:activity_id])
    elsif params[:page_id]
      @activity_context = Page.find(params[:page_id]).activity
    elsif something.respond_to?(:activity)
      @activity_context = something.activity
    else
      @activity_context = nil
    end
  end
end
