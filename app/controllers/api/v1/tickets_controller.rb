class Api::V1::TicketsController < Api::V1::BaseController
  def index
    @bucket = Ticket

    @bucket = @bucket.where(:project_id => params[:project_id])

    @tickets = @bucket.order("name").all
    render :json => @tickets
  end
end
