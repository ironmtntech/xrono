module ApplicationHelper
  include Acl9Helpers

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

  def render_label_for(hour_type)
    label_type = nil
    case hour_type
    when 'Overtime'
      label_type = 'important'
    when 'PTO'
      label_type = 'success'
    when 'CTO'
      label_type = 'warning'
    end
    if label_type
      haml_tag(:div, :class => 'label ' << label_type) do
        haml_concat hour_type
      end
    end
  end

end
