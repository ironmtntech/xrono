class ClientsController < ApplicationController
  before_filter :load_new_client, :only => [:new, :create]
  before_filter :load_client, :only => [:edit, :show, :update]
  before_filter :load_file_attachments, :only => [:show, :new, :create]

  access_control do
    allow :admin

    action :index do
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
      @clients = Client.active.sort_by_name
    else
      @clients = Client.active.for_user(current_user)
    end
  end

  def inactive_clients
    if admin?
      @clients = Client.inactive.sort_by_name
    else
      @clients = Client.inactive.for_user(current_user).sort_by_name
    end
  end

  def suspended_clients
    if admin?
      @clients = Client.suspended.sort_by_name
    else
      @clients = Client.suspended.for_user(current_user).sort_by_name
    end
  end

  def show
    if admin?
      @projects = Project.sort_by_name.for_client(@client)
    else
      @projects = Project.sort_by_name.for_client(@client).for_user(current_user)
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
