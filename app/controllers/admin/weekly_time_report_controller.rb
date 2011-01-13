class Admin::WeeklyTimeReportController < ApplicationController

  def index
    redirect_to('/admin/weekly_time_report/' + Date.today.beginning_of_week.strftime("%F"))
  end

  def show
    redirect_unless_monday('/admin/weekly_time_report/', params[:id])
    @users = User.sort_by_name.select{|u| u.has_role?(:developer) && !u.locked }
  end

end
