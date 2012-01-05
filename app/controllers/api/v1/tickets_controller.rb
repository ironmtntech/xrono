class Api::V1::TicketsController < Api::V1::BaseController
  def index
    @bucket = Ticket

    @bucket = @bucket.where(:project_id => params[:project_id])

    @tickets = @bucket.order("name").all
    render :json => @tickets
  end

  def show
    @ticket = Ticket.find params[:id]

    @pie_chart_url = Gchart.pie(:title => "Remaining Estimated Hours vs Hours Worked -- #{@ticket.percentage_complete}% complete",
      :size => '450x230', :bar_color => "76959c,364447", :data => [100 - @ticket.percentage_complete, @ticket.percentage_complete], :labels => ["Remaining Estimated", "Hours Worked"])
    json_hash = {
        :name           => @ticket.name,
        :pie_chart_url  => @pie_chart_url
    }
    render :json => json_hash
  end
end
