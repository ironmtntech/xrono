class ClientLogin::ReportsController < ClientLogin::BaseController
  before_filter :load_projects, :only => [:work_units]
  def index
  end

  def work_units
    params[:start_date_hidden] ||= Date.current.beginning_of_month.to_s
    params[:end_date_hidden] ||= Date.current.end_of_month.to_s
    start_date = Time.zone.parse(params[:start_date_hidden]).beginning_of_day
    end_date = Time.zone.parse(params[:end_date_hidden]).end_of_day
    if params[:project_id].nil?
      project = Project.for_user(current_user).first
    else
      project = Project.for_user(current_user).find params[:project_id]
    end
    @work_units = WorkUnit.order("scheduled_at desc").for_project(project).scheduled_between(start_date,end_date)
  end

  private
  def load_projects
    @projects = Project.for_user(current_user)
  end
end
