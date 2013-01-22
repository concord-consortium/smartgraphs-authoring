module ApplicationHelper

  def activity_for(child)
    if params[:activity_id]
      @activity_context = Activity.find(params[:activity_id])
    elsif params[:page_id]
      @activity_context = Page.find(params[:page_id]).activity
    elsif child.respond_to?(:activity)
      @activity_context = child.activity
    elsif child.respond_to?(:page)
      @activity_context = child.page.activity
    else
      @activity_context = nil
    end
  end
end
