class Api::BaseController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :verify_authenticity_token
  respond_to :json
end
