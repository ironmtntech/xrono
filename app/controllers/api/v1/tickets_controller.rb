class Api::V1::TicketsController < Api::V1::BaseController

  def index
    @bucket = Ticket

    @project = Project.find_by_id(params["project_id"])
    @bucket = @bucket.for_project(@project) if @project

    @client = Client.find_by_id(params["client_id"])
    @bucket = @bucket.for_client(@client) if @client

    @bucket = @bucket.for_user_scope(current_user)

    @tickets = @bucket.order("name").all
    render :json => @tickets
  end
end
