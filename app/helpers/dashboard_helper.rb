module DashboardHelper

  def external_hours_chart user, date = Time.zone.now
    internal_hours, external_hours, sum_hours = [0],[0],[0]
    (date.beginning_of_week.to_date..date.end_of_week.to_date).each do |i_date|
      internal_hours << user.work_units.scheduled_between(i_date.beginning_of_day,i_date.end_of_day).for_client(@site_settings.client).sum(:hours)
      external_hours << user.work_units.scheduled_between(i_date.beginning_of_day,i_date.end_of_day).except_client(@site_settings.client).sum(:hours)
      sum_hours      << internal_hours.last + external_hours.last
    end
    image_tag Gchart.line( :title => "Hours This Week",
                           :size => "450x150",
                           :data => [internal_hours,external_hours,sum_hours],
                           :line_colors => "FF0000,00FF00,0FFFFF",
                           :legend => ["Internal","External","Total"],
                           :axis_with_labels => ["x","y"],
                           :axis_labels => ["|Mon|Tue|Wed|Thu|Fri|Sat|Sun"])
  end
end
