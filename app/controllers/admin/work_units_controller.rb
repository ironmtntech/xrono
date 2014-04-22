class WorkUnitsController < ApplicationController

  def show
    @work_unit = WorkUnit.find params[:id]
  end

  def search
  end

  def index
    @work_unit = WorkUnit.all
  end

end
