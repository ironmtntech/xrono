class ClientLogin::TicketsController < ClientLogin::BaseController
  before_filter :load_new_ticket, :only => [:new, :create]
  before_filter :load_ticket, :only => [:show, :edit, :update, :advance_state, :reverse_state, :ticket_detail]
  before_filter :load_project

  access_control do
    allow :admin
    allow :developer, :of => :project
    allow :client, :of => :project, :to => :show
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
