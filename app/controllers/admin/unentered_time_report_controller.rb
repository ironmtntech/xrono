class Admin::UnenteredTimeReportController < Admin::BaseController

  def index
    redirect_to("/admin/unentered_time_report/#{Date.current.beginning_of_week.to_s}")
  end

  def show
    redirect_unless_monday('/admin/unentered_time_report/', params[:id])
    @week_dates = build_week_hash_for(Date.parse(params[:id]))
    @users = User.unlocked.developers.uniq
  end

  def load_work_units
    @work_units = current_user.work_units_between(@start_date, @start_date + 6.days)
  end

  protected
  def build_week_hash_for(date, hash={})
    until date.wday == 0 #Sunday
      day = date.strftime("%A")
      hash[day] = date
      date = date.tomorrow
    end
    return hash
  end
end
