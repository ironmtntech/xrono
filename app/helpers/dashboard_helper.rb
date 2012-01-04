require File.expand_path('../../../vendor/gems/gchart/lib/gchart', __FILE__)

module DashboardHelper
  def external_hours_chart(users, options = {})
    users = [users] unless users.is_a?(Array)
    return if @site_settings.client.nil?
    width       = options.fetch(:width, "450x120")
    chart_color = options.fetch(:chart_color, "F9F9F9")
    date        = options.fetch(:date, Time.zone.now)
    title       = options.fetch(:title, "")
    start_date, end_date = date.beginning_of_week.to_date, date.end_of_week.to_date
    internal_hours, external_hours = [],[]
    max_hours = 0
    (start_date..end_date).each do |i_date|
      _beg, _end = i_date.beginning_of_day, i_date.end_of_day
      bucket = WorkUnit.for_users(users).scheduled_between(_beg, _end)
      int = bucket.for_client(@site_settings.client).sum(:hours)
      ext = bucket.except_client(@site_settings.client).sum(:hours)
      internal_hours << int
      external_hours << ext
      max_hours = [max_hours, int, ext].max
    end
    return if (internal_hours.sum < 1 && external_hours.sum < 1)
    image_tag GChart.bar(:title => title,
                         :orientation => :vertical,
                         :axis => [["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], [0, max_hours]],
                         :colors => ['ff0000', '00ff00'],
                         :size => width,
                         :data => [internal_hours,external_hours],
                         :legend => ["Int","Ext"],
                         :extras => {"chf" => "bg,s,00000000"} # Makes fill transparent
                         ).to_url
  end
end
