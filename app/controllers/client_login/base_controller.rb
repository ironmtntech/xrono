class ClientLogin::BaseController < ApplicationController

  def index
    @clients = Client.sort_by_name.for_user current_user
  end

  def show
    @client = Client.find params[:id]
  end

  def projects
    @client = Client.find params[:client_id]
    @projects = Project.sort_by_name.for_client @client
  end

end
