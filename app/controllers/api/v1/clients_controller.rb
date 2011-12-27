class Api::V1::ClientsController < Api::V1::BaseController

  def index
    @clients = Client.order("name").for_user(current_user)
    render :json => @clients
  end
end
