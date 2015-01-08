class Api::V1::CredentialsController < Api::V1::BaseController
  skip_before_filter :verify_api_login
  before_action :doorkeeper_authorize!

  respond_to :json

  def me
    respond_with current_resource_owner
  end
end
