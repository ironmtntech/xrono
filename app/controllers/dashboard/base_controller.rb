class Dashboard::BaseController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  before_filter :get_calendar_details, :only => [:index, :calendar, :update_calendar]
  before_filter :load_work_units, :only => [:index, :calendar, :update_calendar]
  respond_to :html, :json, :js

  def json_index
    bucket = decide_bucket
    bucket = bucket.for_user(current_user) unless params["all"] == "true"
    bucket.order("name")
    render :json => bucket.all
  end

  def index
    @message = {:title => t(:management), :body => t(:enter_time_for_previous_day)} unless current_user.entered_time_yesterday?
    @clients = Client.order("name").active.for_user(current_user)
    @projects = []
    @tickets = []

    @project_report_rows = WorkUnit.for_user(current_user).scheduled_between(Time.zone.now - 2.weeks, Time.zone.now.end_of_day).joins(:ticket => :project).select("projects.name as project_name, projects.id as project_id, SUM(work_units.effective_hours) as total_hours").group("projects.name, projects.id").sort_by{|r| r.total_hours}.reverse # Sort in ruby because I ran into sql problems - should be sorting like 5 rows max so no worries
  end

  def client
    @projects = Project.order("name").incomplete.for_client_id(params[:id])
    unless admin?
      @projects = @projects.for_user_and_role(current_user, :developer)
    end
    respond_with @projects
  end

  def project
    @tickets = Ticket.order("name").incomplete.where("project_id = ?", params[:id])
    #unless admin?
    #  @tickets = @tickets.for_user_and_role(current_user, :developer)
    #end
    respond_with @tickets
  end

  def calendar
  end

  def load_work_units
    @work_units = current_user.work_units_between(@start_date, @start_date + 6.days)
  end

  def update_calendar
    respond_to do |format|
      format.js {
        render :json => {
          :success => true,
          :data => render_to_string(
            :partial => 'shared/calendar',
            :locals => {
              :start_date => @start_date,
              :work_units => @work_units,
              :user => current_user
            }
          ),
          :week_pagination => render_to_string(
            :partial => 'dashboard/base/week_pagination',
            :locals => {
              :start_date => @start_date
            }
          )
        }
      }
    end
  end

  private

  def decide_bucket
    case params["bucket"]
    when "Client"
      Client.active
    when "Project"
      Project.incomplete.where("client_id = ?", params[:id])
    when "Ticket"
      Ticket.incomplete.where("project_id = ?", params[:id])
    end
  end
end
