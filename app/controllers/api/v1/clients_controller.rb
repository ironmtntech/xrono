class Api::V1::ClientsController < Api::V1::BaseController

  def index
    @clients = Client.order("name")
    unless admin?
      @clients = @clients.for_user(current_user)
    end
    @clients = @clients.where(:initials => params[:initials]) unless params[:initials].blank?
    render :json => @clients
  end
end
