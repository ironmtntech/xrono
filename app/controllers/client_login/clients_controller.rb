class ClientLogin::ClientsController < ClientLogin::BaseController
  before_filter :load_client, :only => [:show]

  access_control do
    allow :admin

    action :index do
      allow :client
    end

    action :show do
      allow :client, :if => :user_is_authorized
    end
  end

public
  def index
    bucket = Client.order("name")
    if admin?
      bucket = bucket.all
    else
      bucket = bucket.for_user(current_user)
    end
    @clients = bucket.all
    redirect_to client_login_client_path(@clients.first) if @clients.count == 1
  end

  def show
    bucket = Project.sort_by_name.for_client(@client)
    bucket = bucket.for_user(current_user) unless admin?
    @projects = bucket.all
  end

private
  def user_is_authorized
    @client.allows_access? current_user
  end

  def load_client
    @client = Client.find(params[:id])
  end
end
