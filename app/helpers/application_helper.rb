module ApplicationHelper
  include Acl9Helpers

  def wrapper_class
    if current_user
      "wrapper #{current_user.full_width ? 'full_width' : nil}"
    else
      "wrapper"
    end
  end

  def external_work_percentage(user, start_date, end_date)
    if @site_settings.client
      internal = user.percentage_work_for(@site_settings.client, start_date, end_date)
      (100 - internal).to_s
    end
  end

  def last_effective_date(start_date)
    if start_date.end_of_week > Date.current 
      Date.current
    else
      start_date.end_of_week
    end
  end

end
