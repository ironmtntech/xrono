class ProjectsController < ApplicationController
  include ControllerMixins::Authorization

  before_filter :load_new_project, :only => [:new, :create]
  before_filter :load_project, :only => [:show, :edit, :update]
  before_filter :load_file_attachments, :only => [:show, :new, :create]
  before_filter :handle_tags

  authorize_owners_with_client_show(:project)

  # GET /projects/new
  def new
  end

  # POST /projects
  def create
    if @project.save
      flash[:notice] = t(:project_created_successfully)
      redirect_to @project
    else
      flash.now[:error] = t(:project_created_unsuccessfully)
      render :action => 'new'
    end
  end

  # GET /projects/:id
  def show
    @bucket = Ticket.for_project(@project).sort_by_name

    @incomplete_tickets = @bucket.incomplete
    @complete_tickets = @bucket.complete
    @work_units = Project.find(params[:id]).work_units
  end

  # GET /projects/:id/edit
  def edit
  end

  # PUT /projects/:id
  def update
    if params[:project]["completed"] == "1"
      @project.update_attribute(:completed, true)
    else
      @project.update_attribute(:completed, false)
    end

    @project.update_attributes(params[:project])
    if @project.save
      flash[:notice] = t(:project_updated_successfully)
      redirect_to [@project]
    else
      flash.now[:error] = t(:project_updated_unsuccessfully)
      render :action => 'edit'
    end
  end

  private

    def load_new_project
      @project = Project.new(params[:project])
      @project.client = Client.find(params[:client])
    end

    def load_project
      @project = Project.find(params[:id])
    end

    def load_file_attachments
      @file_attachments = @project.file_attachments
    end

    def handle_tags
      params[:project]['tag_list'] = get_tag_list_for(params[:tags]) if params[:tags]
    end

end
