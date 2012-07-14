class Api::BaseController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_login
  respond_to :json

  def verify_api_login
    render :json => {:success => false} unless current_user && params[:auth_token]
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
