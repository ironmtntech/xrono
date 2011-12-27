class Api::V1::ProjectsController < Api::V1::BaseController

  def index
    @bucket = Project
    @client = Client.find_by_id(params["client_id"])
    @bucket = @bucket.for_user(current_user)
    @bucket = @bucket.for_client(@client) if @client
    @projects = @bucket.order("name").all
    render :json => @projects
  end
end
