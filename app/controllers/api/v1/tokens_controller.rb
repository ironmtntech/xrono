class Api::V1::TokensController < Api::V1::BaseController
  skip_before_filter :verify_authenticity_token

  def create
    @user = User.find_by_email(params["email"])

    if @user.nil?
      render :json => {:success => false} and return
    end

    @user.ensure_authentication_token!

    if @user.valid_password?(params["password"])
      render :json => {:token => @user.authentication_token, :success => true} and return
    else
      render :json => {:success => false} and return
    end
  end
end
