class Api::V1::WorkUnitsController < Api::V1::BaseController
  def index
    get_calendar_details
    bucket = WorkUnit.scheduled_between(@start_date, @start_date + 6.days)
    if params[:external_only]
      client = SiteSettings.first.try(:client)
      bucket = bucket.except_client(client)
    end
    @work_units = bucket.all
    render :json => @work_units
  end

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
