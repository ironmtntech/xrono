class TicketsController < ApplicationController
  include ControllerMixins::Generic
  include ControllerMixins::Tickets
  include ControllerMixins::Authorization

  before_filter :load_new_ticket, :only => [:new, :create]
  before_filter :load_ticket, :only => [:show, :edit, :update, :advance_state, :reverse_state, :ticket_detail, :toggle_complete]
  before_filter :load_file_attachments, :only => [:show, :new, :create]
  before_filter :load_project

  authorize_owners_with_client_show(:project)

  def new
  end

  def create
    create!(:ticket_path) # In ControllerMixins::Tickets module
  end

  def show
    @work_units = WorkUnit.for_ticket(@ticket).sort_by_scheduled_at
    unless @ticket.estimated_hours
      flash.now[:notice] = "NOTE: The estimated amount of time to complete this ticket has not been entered."
    end

    if @ticket.percentage_complete.to_i > 100
      flash.now[:notice] = "WARNING: Ticket has exceeded the estimated amount of time to be completed."
    end
  end

  def edit
  end

  def update
    @ticket.update_attributes(params[:ticket])
    generic_save_and_redirect(:ticket, :update)
  end

  private
  def load_file_attachments
    @file_attachments = @ticket.file_attachments
  end

  # Acl9's access control block looks for @project in order to use "allow <role> :of => :project"
  def load_project
    @project = @ticket.project
  end
end
