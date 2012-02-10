require 'controller_mixins/work_units'

class ClientLogin::WorkUnitsController < ClientLogin::BaseController
  include ControllerMixins::WorkUnits

  access_control do
    allow :admin
    allow :developer, :of => :project
    allow :client, :of => :project, :to => :show
  end

  # GET /work_units/:id
  def show
    @work_unit = WorkUnit.find params[:id]
  end

end
