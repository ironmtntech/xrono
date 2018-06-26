class ClientsController < ApplicationController
  include ControllerMixins::Generic

  before_filter :load_new_client, :only => [:new, :create]
  before_filter :load_client, :only => [:edit, :show, :update]
  before_filter :load_file_attachments, :only => [:show, :new, :create]

  access_control do
    allow :admin
    allow :developer, :to => [:index, :inactive_clients, :suspended_clients, :show_complete, :project_subscribe, :project_unsubscribe, :show, :historical_time, :all_clients, :active_clients]

    action :index do
      allow :developer
      allow :client
    end

    action :inactive_clients do
      allow :developer
    end

    action :suspended_clients do
      allow :developer
    end

    action :show_complete do
      allow :developer
      allow :client
    end

    action :show do
      allow :developer, :if => :user_is_authorized
      allow :client, :if => :user_is_authorized
    end

    action :project_subscribe do
      allow :developer
    end
    
    action :project_unsubscribe do
      allow :developer
    end
  end

  protected
  def load_new_client
    @client = Client.new(params[:client])
  end

  def load_client
    @client = Client.find(params[:id])
  end

  def load_file_attachments
    @file_attachments = @client.file_attachments
  end

  public
  def index
    @clients = authorized_clients.active
  end
 
  def active_clients
    @clients = Client.order("name").active
  end 

  def inactive_clients
    @clients = Client.order("name").inactive
  end

  def suspended_clients
    @clients = Client.order("name").suspended
  end

  def all_clients
    @clients = Client.order("name")
  end

  def show
    @bucket = Project.order("name").for_client(@client)
    #@bucket = @bucket.for_user(current_user) unless admin?

    @work_units = WorkUnit.for_client(@client).order("work_units.created_at DESC").limit(100)

    @incompleted_projects = @bucket.incomplete
    @completed_projects = @bucket.complete
  end

  def export_work_units
    if params[:scope] == 'projects'
      @project = Project.find(params[:project_id])
      @work_units = WorkUnit.for_project(@project)
    elsif params[:scope] == 'clients'
      @client = Client.find(params[:client_id])
      @work_units = WorkUnit.for_client(@client)
    end
    _params = params[:export_date]
    @start_date = Date.parse("#{_params['start_date(1i)']}/#{_params['start_date(2i)']}/#{_params['start_date(3i)']}")
    @end_date = Date.parse("#{_params['end_date(1i)']}/#{_params['end_date(2i)']}/#{_params['end_date(3i)']}") + 1.days
    @work_units = @work_units.where(created_at: @start_date..@end_date)
    send_data @work_units.to_csv, filename: "work_units_#{@start_date}_to_#{@end_date}.csv"
  end

  def new
  end

  def create
    generic_save_and_redirect(:client, :create)
  end

  def update
    if @client.update_attributes(params[:client])
      flash[:notice] = t(:client_updated_successfully)
      redirect_to client_path(@client)
    else
      flash.now[:error] = t(:client_updated_unsuccessfully)
      render :edit
    end
  end

  def edit
  end

  def project_subscribe
    project = Project.find(params[:project_id])
    current_user.has_role!(:developer, project)
    current_user.has_role!(:developer, project.client)
    redirect_to client_path project.client
  end

  def project_unsubscribe
    project = Project.find(params[:project_id])
    current_user.has_no_roles_for!(project)
    current_user.has_role!(:developer, project.client)
    redirect_to client_path project.client
  end

  private
  def user_is_authorized
    @client.allows_access? current_user
  end

  def authorized_clients
    if admin?
      Client.order("name")
    else
      Client.order("name").for_user(current_user)
    end
  end
end
