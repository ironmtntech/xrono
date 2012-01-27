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
    if params[:project].present?
      @project = Project.create(params[:project])
      #@project.tickets.create(params[:ticket])
      respond_with(@project)
    elsif params[:ticket].present?
      @ticket = Ticket.create(params[:ticket])
      project_id = Project.last.id
      @ticket.update_attributes(:project_id => project_id)
      respond_with(@ticket)
    end
  end

end
