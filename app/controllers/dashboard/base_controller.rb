class Dashboard::BaseController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  before_filter :get_calendar_details, :only => [:index, :calendar, :update_calendar]
  respond_to :html, :json, :js

  ##############################################################################
  # Methods called by checkbox to display full list of clients/projects/tickets#
  # for developers who want to bill on a project they are not assigned to.     #
  ##############################################################################
  
  # Show ALL clients                                                           #
  def collaborative_index
    @clients = Client.not_inactive.sort_by_name
    @projects = []
    @tickets = []
    render :json => @clients
  end

  # Show ALL projects                                                          #
  def collaborative_client
    @projects = Project.find(:all, :conditions => {:client_id => params[:id]}, :order => "name")
    render :json => @projects
  end
  
  # Show ALL tickets                                                           #
  def collaborative_project
    @tickets = Ticket.find(:all, :conditions => {:project_id => params[:id]}, :order => "name")
    render :json => @tickets
  end

  # Undoes effects of checkbox, rendering only the clients for which developer #
  # has projects assigned.                                                     #
  def json_index
    @clients = Client.not_inactive.sort_by_name.for_user(current_user)
    @projects = []
    @tickets = []
    render :json => @clients
  end
  
  ##############################################################################
  # Regular scoped methods                                                     #
  ##############################################################################
  def index
    if current_user.has_role?(:developer)
      unless current_user.work_units_for_day(Date.current.prev_working_day).any?
        @message = {:title => t(:management),
          :body => t(:enter_time_for_previous_day)}
      end
    end
    @clients = Client.not_inactive.sort_by_name.for_user(current_user)
    @projects = []
    @tickets = []
  end

  def client
    @projects = Project.sort_by_name.for_client_id(params[:id])
    unless admin?
      @projects = @projects.for_user_and_role(current_user, :developer)
    end
    respond_with @projects
  end

  def project
    @tickets = Ticket.find(:all, :conditions => {:project_id => params[:id]}, :order => "name")
    #unless admin?
     # @tickets = @tickets.for_user_and_role(current_user, :developer)
    #end
    respond_with @tickets
  end
  def index
    if current_user.has_role?(:developer)
      unless current_user.work_units_for_day(Date.current.prev_working_day).any?
        @message = {:title => t(:management),
          :body => t(:enter_time_for_previous_day)}
      end
    end
    @clients = Client.not_inactive.sort_by_name.for_user(current_user)
    @projects = []
    @tickets = []
  end

  def client
    @projects = Project.sort_by_name.for_client_id(params[:id])
    unless admin?
      @projects = @projects.for_user_and_role(current_user, :developer)
    end
    respond_with @projects
  end

  def project
    @tickets = Ticket.sort_by_name.for_project_id(params[:id])
    unless admin?
      @tickets = @tickets.for_user_and_role(current_user, :developer)
    end
    respond_with @tickets
  end

  def calendar
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

  def get_calendar_details
    if params[:date].present? && params[:date] != "null"
      @start_date = Date.parse(params[:date]).beginning_of_week
    else
      @start_date = Date.current.beginning_of_week
    end
  end
end
