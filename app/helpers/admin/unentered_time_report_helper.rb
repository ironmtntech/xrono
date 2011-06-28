module Admin::UnenteredTimeReportHelper
  def hours_entered_for_day time
    hours = 0
    @users.each do |u|
      hours += u.hours_entered_for_day(time)
    end
    hours
  end
end
