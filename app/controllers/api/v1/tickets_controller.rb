class Api::V1::TicketsController < Api::V1::BaseController
  def index
    @bucket = Ticket.order("name")

    @bucket = @bucket.where(:project_id => params[:project_id]) unless params[:project_id].blank?
    @bucket = @bucket.for_repo_url_and_branch(params[:repo_url],params[:branch]) unless params[:repo_url].blank? && params[:branch].blank?

    json_array = []
    @bucket.all.each do |ticket|
      json_array << build_hash_for_ticket(ticket)
    end
    render :json => json_array
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
      render :json => {:success => false, :errors => @ticket.errors.full_messages.to_sentence} and return
    end
  end

  private
  def build_hash_for_ticket ticket
      {
          :id                   => ticket.id,
          :name                 => ticket.name,
          :estimated_hours      => ticket.estimated_hours,
          :percentage_complete  => ticket.percentage_complete,
          :hours                => ticket.hours
      }
  end
end
