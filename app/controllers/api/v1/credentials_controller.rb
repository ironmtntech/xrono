class Api::V1::CredentialsController < Api::V1::BaseController
  skip_before_filter :verify_api_login
  doorkeeper_for :all

  respond_to :json

  def me
    respond_with current_resource_owner
  end
end
