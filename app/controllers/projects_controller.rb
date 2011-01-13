class ProjectsController < ApplicationController
  before_filter :load_new_project, :only => [:new, :create]
  before_filter :load_project, :only => [:show, :edit, :update]
  before_filter :load_file_attachments, :only => [:show, :new, :create]
  access_control do
    allow :admin
    allow :developer, :of => :project
    allow :client, :of => :project, :to => [:show]
  end

  protected
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

  public

  def show
    @tickets = Ticket.for_project(@project).sort_by_name
  end

  def new
  end

  def edit
  end

  def update
    if @project.update_attributes(params[:project])
      flash[:notice] = t(:project_updated_successfully)
      redirect_to [@project]
    else
      flash.now[:error] = t(:project_updated_unsuccessfully)
      render :action => 'edit'
    end
  end

  def create
    if @project.save
      flash[:notice] = t(:project_created_successfully)
      redirect_to @project
    else
      flash.now[:error] = t(:project_created_unsuccessfully)
      render :action => 'new'
    end
  end

end
