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

  def activity_errors(item=nil)
    activity    = nil
    activity   = item if (item.class == Activity)
    activity ||= item.sg_activity if (item.respond_to? :sg_activity)
    return "" unless activity
    return "" if activity.activity_errors.blank?
    return "<div class='activity-errors'>#{activity.activity_errors}</div>".html_safe
  end
end
