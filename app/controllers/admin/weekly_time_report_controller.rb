class Admin::WeeklyTimeReportController < Admin::BaseController
  def index
    redirect_to('/admin/weekly_time_report/' + Date.current.beginning_of_week.strftime("%F"))
  end

  def show
    redirect_unless_monday('/admin/weekly_time_report/', params[:id])
    @users = User.sort_by_name.select{|u| u.has_role?(:developer) && !u.locked }
    @weekly_hours_sum = ChartData.external_hours_for_chart(@users, :date => @start_date)
  end
end
