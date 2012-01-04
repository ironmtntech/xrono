module DashboardHelper

  def external_hours_chart(user, options = {})
    return if @site_settings.client.nil?
    width       = options.fetch(:width, "450x120")
    chart_color = options.fetch(:chart_color, "F9F9F9")
    date        = options.fetch(:date, Time.zone.now)
    title       = options.fetch(:title, "")
    internal_hours, external_hours = [0],[0]
    #Step through each day in the week and build an array of internal and external hours
    (date.beginning_of_week.to_date..date.end_of_week.to_date).each do |i_date|
      internal_hours << user.work_units.scheduled_between(i_date.beginning_of_day,i_date.end_of_day).for_client(@site_settings.client).sum(:hours)
      external_hours << user.work_units.scheduled_between(i_date.beginning_of_day,i_date.end_of_day).except_client(@site_settings.client).sum(:hours)
    end
    if (internal_hours.sum < 1 && external_hours.sum < 1)
      return
    else
      internal_hours.map!{|hours| hours == 0 ? nil : hours}
      external_hours.map!{|hours| hours == 0 ? nil : hours}
      image_tag Gchart.line( :title => title,
                             :size => width,
                             :data => [internal_hours,external_hours],
                             :line_colors => "FF0000,00FF00,0FFFFF",
                             :legend => ["Internal","External"],
                             :background => chart_color,
                             :axis_with_labels => ["x","y"],
                             :axis_labels => ["|Mon|Tue|Wed|Thu|Fri|Sat|Sun"])
    end
  end
end
