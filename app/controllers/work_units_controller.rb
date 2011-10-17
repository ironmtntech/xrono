class WorkUnitsController < ApplicationController
  before_filter :load_new_work_unit, :only => [:new, :create_in_dashboard]
  before_filter :check_for_params, :only => [:create_in_dashboard]
  before_filter :load_work_unit, :only => [:show, :edit, :update]
  before_filter :require_admin, :only => [:index]
  access_control do
    allow :admin
    allow :developer, :of => :project
    
    allow :client, :of => :project, :to => :show
  end
  
  # GET /work_units/new
  def new
  end
  
  # POST /work_units
  def create_in_dashboard
    if request.xhr?
      if @work_unit.save
        suspended = @work_unit.client.status == "Suspended"
        if suspended
          render :json => "{\"success\": true, \"notice\": \"This client is suspended. Please contact an Administrator.\"}",
          :layout => false,
          :status => 200 and return
        else
          render :json => "{\"success\": true}", :layout => false, :status => 200 and return
        end
      else
        render :json => @work_unit.errors.full_messages.to_json, :layout => false, :status => 406 and return
        flash[:error] = t(:work_unit_created_unsuccessfully)
      end
    end
  end
  def create_in_ticket
    @work_unit = WorkUnit.new(params[:work_unit])
    @work_unit.user = current_user
    if @work_unit.save
      flash[:notice] = "Work Unit created successfully"
      redirect_to ticket_path(@work_unit.ticket)
    else
      flash[:error] = "There was a problem creating the work unit."
      render :template => 'work_units/new'
    end
    
  end

  def index 
    if params[:invoiced] != nil
      @work_units = WorkUnit.find_all_by_invoiced(params[:invoiced])
      @search = "Invoiced: " + params[:invoiced]
    else
      @work_units = WorkUnit.find_all_by_paid(params[:paid])
      @search = "Paid: " + params[:paid]
    end
  end

  # GET /work_units/:id
  def show
  end

  # GET /work_units/:id/edit
  def edit
  end

  # PUT /work_units/:id
  def update
    if @work_unit.update_attributes(params[:work_unit])
      @work_unit.send_email!
      flash[:notice] = t(:work_unit_updated_successfully)
      redirect_to @work_unit
    else
      flash.now[:error] = t(:work_unit_updated_unsuccessfully)
      redirect_to edit_work_unit_path
    end
  end

  private

    def check_internal_client
      compare = params[:work_unit][:client_id].to_i
      if compare == SiteSettings.first.client_id
        return true
      end
      false
    end
    def check_for_params
      if params[:work_unit][:client_id].blank?
        render :json => {:success => false, :errors => "You must select a client." }, :layout => false, :status => 406 and return
      elsif params[:work_unit][:project_id].blank?
        render :json => {:success => false, :errors => "You must select a project." }, :layout => false, :status => 406 and return
      elsif params[:work_unit][:ticket_id].blank?
        render :json => {:success => false, :errors => "You must select a ticket." }, :layout => false, :status => 406 and return
      elsif params[:work_unit][:hours].blank?
        render :json => {:success => false, :errors => "You must input number of hours." }, :layout => false, :status => 406 and return
      elsif params[:hours_type].blank?
        render :json => {:success => false, :errors => "You must select an hours type." }, :layout => false, :status => 406 and return
      elsif params[:work_unit][:description].blank?
        render :json => {:success => false, :errors => "You must supply a description for the work unit." }, :layout => false, :status => 406 and return
      elsif params[:hours_type] == "CTO" && !check_internal_client
        render :json => {:success => false, :errors => "You can only select CTO as hours type on internal client." }, :layout => false, :status => 406 and return
      end
    end

    def load_new_work_unit
      _params = (params[:work_unit] || {}).dup
      _params.delete :client_id
      _params.delete :project_id
      # ticket_id is sent as a child of work unit from the dashboard page, but not from the new work unit page.
      # consequently, we'll find it wherever it may be
      ticket_id = params[:ticket_id] || _params[:ticket_id]
      @ticket    = Ticket.find ticket_id
      @work_unit = WorkUnit.new(_params)
      @work_unit.user = current_user
      @work_unit.ticket = @ticket
      @work_unit.scheduled_at ||= Date.today
      #if _params[:scheduled_at].present?
      #  @work_unit.scheduled_at = Time.zone.parse(_params[:scheduled_at])
      #end
      @work_unit.hours_type = params[:hours_type]
    end

    def load_work_unit
      @work_unit = WorkUnit.find(params[:id])
    end

end
