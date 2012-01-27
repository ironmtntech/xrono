class Api::V1::ClientsController < Api::V1::BaseController

  def index
    if current_user.present?
      @clients = Client.order("name").for_user(current_user)
    else
      @clients = Client.all
    end
    render :json => @clients
  end

  def create
    @client = Client.create(params[:client])
    @contact = @client.contacts.create(params[:contact])
    respond_with(@client)
  end

end
