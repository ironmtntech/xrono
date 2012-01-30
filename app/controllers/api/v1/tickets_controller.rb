class Api::V1::TicketsController < Api::V1::BaseController
  def index
    @bucket = Ticket

    @bucket = @bucket.where(:project_id => params[:project_id]) unless params[:project_id].blank?
    @bucket = @bucket.for_repo_url_and_branch(params[:repo_url],params[:branch]) unless params[:repo_url].blank? && params[:branch].blank?

    @tickets = @bucket.order("name").all
    json_array = []
    @tickets.each do |ticket|
      json_hash = {
          :id                   => ticket.id,
          :name                 => ticket.name,
          :estimated_hours      => ticket.estimated_hours,
          :percentage_complete  => ticket.percentage_complete,
          :hours                => ticket.hours
      }
      json_array << json_hash
    end
    Rails.logger.warn json_array.to_json
    render :json => json_array.to_json
  end

  def show
    @ticket = Ticket.find params[:id]

    json_hash = {
        :name                 => @ticket.name,
        :estimated_hours      => @ticket.estimated_hours,
        :percentage_complete  => @ticket.percentage_complete,
        :hours                => @ticket.hours
    }
    render :json => json_hash
  end

  def create
    @ticket = Ticket.new(params[:ticket])
    if @ticket.save
      render :json => {:success => true} and return
    else
      Rails.logger.warn @ticket.errors.full_messages.to_sentence
      render :json => {:succes => false, :errors => @ticket.errors.full_messages.to_sentence} and return
    end
  end
end
