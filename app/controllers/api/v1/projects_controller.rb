class Api::V1::ProjectsController < Api::V1::BaseController
  def index
    @bucket = Project
    @bucket = @bucket.sort_by_name.for_client_id(params[:client_id])
    unless admin?
      @bucket = @bucket.for_user(current_user)
    end
    @projects = @bucket.order("name").all
    render :json => @projects
  end

  def create
    @project = Project.create(params[:project])
    respond_with(@project)
  end

end
