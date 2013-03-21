module ChartData
  def self.external_hours_for_chart(users, options = {})
    users                 = Array(users)
    date                  = options.fetch(:date, Time.zone.now)
    start_date, end_date  = date.beginning_of_week.to_date, date.end_of_week.to_date

    final_array = []
    (start_date..end_date).each do |i_date|
      _beg, _end = i_date.beginning_of_day, i_date.end_of_day
      hours = WorkUnit.for_users(users).scheduled_between(_beg,_end).all
      final_array << [i_date.strftime("%a"), sum_hours(:external?, hours).to_f, sum_hours(:internal?, hours).to_f]
    end
    final_array
  end

  protected
  def self.sum_hours(method, hours)
    hours.select{|wu| wu.send(method) }.sum(&:hours)
  end
end
