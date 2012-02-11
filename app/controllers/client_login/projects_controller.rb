class ClientLogin::ProjectsController < ClientLogin::BaseController
  include ControllerMixins::Authorization

  before_filter :load_project, :only => [:show]
  before_filter :load_file_attachments, :only => [:show]

  authorize_owners_with_client_show(:project)

  # GET /projects/:id
  def show
    @tickets = Ticket.for_project(@project).sort_by_name
    # FIXME - not showing correct group of work_units
    @work_units = Project.find(params[:id]).work_units
  end

  private
  def load_project
    @project = Project.find(params[:id])
  end

  def load_file_attachments
    @file_attachments = @project.file_attachments
  end
end
