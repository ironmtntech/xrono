class ClientLogin::WorkUnitsController < ClientLogin::BaseController
  include ControllerMixins::WorkUnits
  include ControllerMixins::Authorization

  authorize_owners_with_client_show(:project)

  # GET /work_units/:id
  def show
    @work_unit = WorkUnit.find params[:id]
  end
end
