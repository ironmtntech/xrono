class Api::V1::WorkUnitsController < Api::V1::BaseController
  def create
    @work_unit = WorkUnit.new(params[:work_unit])
    @work_unit.user = current_user
    if @work_unit.save
      render :json => {:success => true} and return
    else
      Rails.logger.warn @work_unit.errors.full_messages.to_sentence
      render :json => {:succes => false, :errors => @work_unit.errors.full_messages.to_sentence} and return
    end
  end
end
