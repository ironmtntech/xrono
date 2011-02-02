class WorkUnitsController < ApplicationController
  before_filter :check_for_params, :only => [:create]
  before_filter :load_new_work_unit, :only => [:new, :create]
  before_filter :load_work_unit, :only => [:show, :edit, :update]
  before_filter :require_access

  access_control do
    allow :admin
    allow :developer, :of => :project
    allow :client, :of => :project, :to => :show
  end

  protected

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
    end
  end

  def load_new_work_unit
    _params = (params[:work_unit] || {}).dup
    _params.delete :client_id
    _params.delete :project_id
    @work_unit = WorkUnit.new(_params)
    @work_unit.user = current_user
    @work_unit.scheduled_at = Time.zone.parse(_params[:scheduled_at])
    @work_unit.hours_type = params[:hours_type]
  end

  def load_work_unit
    @work_unit = WorkUnit.find(params[:id])
  end

  public

  def new
  end

  def create
    if @work_unit.save
      suspended = @work_unit.client.status == "Suspended"
      if request.xhr?
        if suspended
          render :json => "{\"success\": true, \"notice\": \"This client is suspended. Please contact an Administrator.\"}",
                 :layout => false,
                 :status => 200 and return
        else
          render :json => "{\"success\": true}", :layout => false, :status => 200 and return
        end
      end
    else
      if request.xhr?
        render :json => @work_unit.errors.full_messages.to_json, :layout => false, :status => 406 and return
      end
      flash[:error] = t(:work_unit_created_unsuccessfully)
      redirect_to dashboard_path and return
    end
  end

  def show
  end

  def edit
  end

  def update
    if @work_unit.update_attributes(params[:work_unit])
      flash[:notice] = t(:work_unit_updated_successfully)
      redirect_to @work_unit
    else
      flash.now[:error] = t(:work_unit_updated_unsuccessfully)
      redirect_to edit_work_unit_path
    end
  end

  private

  def require_access
    unless @work_unit.allows_access?(current_user)
      flash[:notice] = t(:access_denied)
      redirect_to root_path
    end
  end
end
