class ClientsController < ApplicationController
  include ControllerMixins::Generic

  before_filter :load_new_client, :only => [:new, :create]
  before_filter :load_client, :only => [:edit, :show, :update]
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
    @clients = authorized_clients.active
    get_recent_users_for_clients
  end

  def inactive_clients
    @clients = authorized_clients.inactive
    get_recent_users_for_clients
  end

  def suspended_clients
    @clients = authorized_clients.suspended
    get_recent_users_for_clients
  end

  def show
    @bucket = Project.order("name").for_client(@client)
    @bucket = @bucket.for_user(current_user) unless admin?

    @incompleted_projects = @bucket.incomplete
    @completed_projects = @bucket.complete
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
      render :action => 'edit'
    end
  end

  def edit
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

  def get_recent_users_for_clients
    @recent_users_for_clients = {}
    @clients.each do |client|
      @recent_users_for_clients[client.id] = WorkUnit.for_client(client).scheduled_between(2.weeks.ago, Time.zone.now).select("distinct user_id").includes(:user).map(&:user)
    end
  end
end
