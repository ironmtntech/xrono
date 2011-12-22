class ClientLogin::WorkUnitsController < ClientLogin::BaseController

  access_control do
    allow :admin
    allow :developer, :of => :project
    allow :client, :of => :project, :to => :show
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
    @work_unit = WorkUnit.find params[:id]
  end

end
