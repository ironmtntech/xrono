class Api::V1::TicketsController < Api::V1::BaseController
  def index
    @bucket = Ticket

    @bucket = @bucket.where(:project_id => params[:project_id]) unless params[:project_id].blank?
    @bucket = @bucket.for_repo_url_and_branch(params[:repo_url],params[:branch]) unless params[:repo_url].blank? && params[:branch].blank?

    @tickets = @bucket.order("name").all
    Rails.logger.warn @tickets.to_json
    render :json => @tickets
  end

  def show
    @ticket = Ticket.find params[:id]

    json_hash = {
        :name           => @ticket.name,
    }
    if @ticket.estimated_hours && @ticket.percentage_complete
      @pie_chart_url = Gchart.pie(:title => "Remaining Estimated Hours vs Hours Worked -- #{@ticket.percentage_complete}% complete",
        :size => '450x230', :bar_color => "76959c,364447", :data => [100 - @ticket.percentage_complete, @ticket.percentage_complete], :labels => ["Remaining Estimated", "Hours Worked"])
      json_hash[:pie_chart_url] = @pie_chart_url
    end
    render :json => json_hash
  end
end
