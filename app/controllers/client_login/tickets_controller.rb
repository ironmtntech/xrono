class ClientLogin::TicketsController < ClientLogin::BaseController
  before_filter :load_new_ticket, :only => [:new, :create]
  before_filter :load_ticket, :only => [:show, :edit, :update, :advance_state, :reverse_state, :ticket_detail]
  before_filter :load_project

  access_control do
    allow :admin
    allow :developer, :of => :project
    allow :client, :of => :project, :to => [:show, :new, :create]
  end

  # GET /tickets/new
  def new
  end

  # POST /tickets
  def create
    if @ticket.save
      if request.xhr?
        flash.now[:notice] = t(:ticket_created_successfully)
        render :json => "{\"success\": true}", :layout => false, :status => 200 and return
      else
        flash[:notice] = t(:ticket_created_successfully)
      end
      redirect_to client_login_ticket_path(@ticket) and return
    else
      if request.xhr?
        render :json => @ticket.errors.full_messages.to_json, :layout => false, :status => 406 and return
      end
      flash[:error] = t(:ticket_created_unsuccessfully)
      render :action => :new and return
    end
  end

  # GET /tickets/:id
  def show
    @work_units = WorkUnit.for_ticket(@ticket).sort_by_scheduled_at
    unless @ticket.estimated_hours
      flash.now[:notice] = "NOTE: The estimated amount of time to complete this ticket has not been entered."
    end

    if @ticket.percentage_complete.to_i > 100
      flash.now[:notice] = "WARNING: Ticket has exceeded the estimated amount of time to be completed."
    end
  end

  private

    def load_new_ticket
      @ticket = Ticket.new(params[:ticket])
      @ticket.project = Project.find(params[:project_id]) if params[:project_id]
    end

    def load_ticket
      if params[:id]
        @ticket = Ticket.find(params[:id])
      elsif params[:ticket_id]
        @ticket = Ticket.find(params[:ticket_id])
      end
    end

    # Acl9's access control block looks for @project in order to use "allow <role> :of => :project"
    def load_project
      @project = @ticket.project
    end
end
