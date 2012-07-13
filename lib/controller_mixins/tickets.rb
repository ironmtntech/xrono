module ControllerMixins
  module Tickets
    def create!(path)
      if @ticket.save
        if request.xhr?
          flash.now[:notice] = t(:ticket_created_successfully)
          render :json => "{\"success\": true}", :layout => false, :status => 200 and return
        else
          flash[:notice] = t(:ticket_created_successfully)
        end
        redirect_to send(path, @ticket) and return
      else
        if request.xhr?
          render :json => @ticket.errors.full_messages.to_json, :layout => false, :status => 406 and return
        end
        flash[:error] = t(:ticket_created_unsuccessfully)
        render :action => :new and return
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
  end
end
