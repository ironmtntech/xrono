class Api::V1::ProjectsController < Api::V1::BaseController
  before_filter :load_client_from_client_initials, :only => [:index]

  def index
    @bucket = Project.sort_by_name
    @bucket = @bucket.for_client_id(params[:client_id]) unless params[:client_id].blank?
    @bucket = @bucket.where(:git_repo_url => params[:git_repo_url]) unless params[:git_repo_url].blank?
    unless admin?
      @bucket = @bucket.for_user(current_user)
    end
    render :json => @bucket.all
  end

  private
  def load_client_from_client_initials
    params[:client_id] = Client.where(:initials => params[:client_initials]).first.id unless params[:client_initials].blank?
  end
end
