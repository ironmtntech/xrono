class Api::V1::TicketsController < Api::V1::BaseController

  def index
    @bucket = Ticket

    @project = Project.find_by_id(params["project_id"])
    @bucket = @bucket.for_project(@project) if @project

    @tickets = @bucket.order("name").all
    render :json => @tickets
  end
end
