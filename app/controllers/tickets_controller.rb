class TicketsController < ApplicationController
  before_filter :load_new_ticket, :only => [:new, :create]
  before_filter :load_ticket, :only => [:show, :edit, :update]
  before_filter :load_file_attachments, :only => [:show, :new, :create]
  before_filter :require_access

  access_control do
    allow :admin
    allow :developer, :of => :project
    allow :client, :of => :project, :to => :show
  end

  protected

  def load_new_ticket
    @ticket = Ticket.new(params[:ticket])
    @ticket.project = Project.find(params[:project_id]) if params[:project_id]
  end

  def load_ticket
    @ticket = Ticket.find(params[:id])
  end

  def load_file_attachments
    @file_attachments = @ticket.file_attachments
  end

  public

  def new
  end

  def show
    @work_units = WorkUnit.for_ticket(@ticket).sort_by_scheduled_at
  end

  def edit
  end

  def update
    if @ticket.update_attributes(params[:ticket])
      flash[:notice] = t(:ticket_updated_successfully)
      redirect_to ticket_path(@ticket)
    else
      flash.now[:error] = t(:ticket_updated_unsuccessfully)
      render :action => 'edit'
    end
  end

  def create
    if @ticket.save
      if request.xhr?
        render :json => "{\"success\": true}", :layout => false, :status => 200 and return
      end
      flash[:notice] = t(:ticket_created_successfully)
      redirect_to ticket_path(@ticket) and return
    else
      if request.xhr?
        render :json => @ticket.errors.full_messages.to_json, :layout => false, :status => 406 and return
      end
      flash.now[:error] = t(:ticket_created_unsuccessfully)
      render :action => :new and return
    end
  end

  def edit
  end

  private

  def require_access
    unless @ticket.allows_access? current_user
      flash[:notice] = "Access denied."
      redirect_to root_path
    end
  end

end
