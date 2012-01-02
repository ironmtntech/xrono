class Api::V1::TicketsController < Api::V1::BaseController
  def index
    @bucket = Ticket

    @bucket = @bucket.find(:all, :conditions => {:project_id => params[:project_id]}, :order => "name")

    @tickets = @bucket.order("name").all
    render :json => @tickets
  end
end
