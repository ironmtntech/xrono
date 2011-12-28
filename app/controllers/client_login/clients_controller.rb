class ClientLogin::ClientsController < ClientLogin::BaseController
  before_filter :load_client, :only => [:show]

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
  def load_client
    @client = Client.find(params[:id])
  end

public
  def index
    if admin?
      @clients = Client.order("name").all
    else
      @clients = Client.order("name").for_user(current_user)
    end
  end

  def show
    if admin?
      @projects = Project.sort_by_name.for_client(@client)
    else
      @projects = Project.sort_by_name.for_client(@client).for_user(current_user)
    end
  end

private
  def user_is_authorized
    @client.allows_access? current_user
  end

end
