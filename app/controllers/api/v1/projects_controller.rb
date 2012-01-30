class Api::V1::ProjectsController < Api::V1::BaseController
  def index
    @bucket = Project.sort_by_name
    params[:client_id] = Client.where(:initials => params[:client_initials]).first.id unless params[:client_initials].blank?
    @bucket = @bucket.for_client_id(params[:client_id]) unless params[:client_id].blank?
    unless admin?
      @bucket = @bucket.for_user(current_user)
    end
    @projects = @bucket.order("name").all
    render :json => @projects
  end
end
