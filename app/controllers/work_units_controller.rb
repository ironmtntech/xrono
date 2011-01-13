class WorkUnitsController < ApplicationController
  before_filter :load_new_work_unit, :only => [:new, :create]
  before_filter :load_work_unit, :only => [:show, :edit, :update]
  before_filter :require_access

  access_control do
    allow :admin
    allow :developer, :of => :project
    allow :client, :of => :project, :to => :show
  end

  protected

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
