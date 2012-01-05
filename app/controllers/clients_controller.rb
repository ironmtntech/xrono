class ClientsController < ApplicationController
  before_filter :load_new_client, :only => [:new, :create]
  before_filter :load_client, :only => [:edit, :show, :show_completed, :update]
  before_filter :load_file_attachments, :only => [:show, :new, :create]

  access_control do
    allow :admin

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
    if admin?
      @clients = Client.order("name").active
    else
      @clients = Client.order("name").active.for_user(current_user)
    end
  end

  def inactive_clients
    if admin?
      @clients = Client.order("name").inactive
    else
      @clients = Client.order("name").inactive.for_user(current_user)
    end
  end

  def suspended_clients
    if admin?
      @clients = Client.order("name").suspended
    else
      @clients = Client.order("name").suspended.for_user(current_user)
    end
  end

  def show
    if admin?
      @incompleted_projects = Project.order("name").incomplete.for_client(@client)
    else
      @incompleted_projects = Project.order("name").incomplete.for_client(@client).for_user(current_user)
    end
  end

  def show_complete
    @client = Client.find params[:client_id]
    if admin?
      @completed_projects = Project.order("name").complete.for_client(@client)
    else
      if @client.allows_access? current_user
        @completed_projects = Project.order("name").complete.for_client(@client).for_user(current_user)
      else
        access_denied
      end
    end
  end

  def new
  end

  def create
    if @client.save
      flash[:notice] = t(:client_created_successfully)
      redirect_to client_path(@client)
    else
      flash.now[:error] = t(:client_created_unsuccessfully)
      render :action => 'new'
    end
  end

  def update
    if @client.update_attributes(params[:client])
      flash[:notice] = t(:client_updated_successfully)
      redirect_to client_path(@client)
    else
      flash.now[:error] = t(:client_updated_unsuccessfully)
      render :action => 'edit'
    end
  end

  def edit
  end

  private

  def user_is_authorized
    @client.allows_access? current_user
  end

end
