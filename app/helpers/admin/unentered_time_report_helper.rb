module Admin::UnenteredTimeReportHelper
  def hours_entered_for_day
    hours = 0
    @users.each do |u|
      hours += u.hours_entered_for_day(Time.now)
    end
    hours
  end
end
