class Api::V1::TokensController < Api::V1::BaseController
  skip_before_filter :verify_api_login

  def create
    @user = User.find_by_email(params["email"])

    if @user.nil?
      render :json => {:success => false} and return
    end

    @user.ensure_authentication_token!

    if @user.valid_password?(params["password"])
      json_hash = {
        :token              => @user.authentication_token,
        :success            => true,
        :admin              => @user.admin?,
        :current_hours      => @user.unpaid_work_units.sum(:effective_hours),
        :pto_hours          => @user.pto_hours_left(Date.today.end_of_week),
        :offset             => @user.target_hours_offset(Date.today),
        :client             => @user.client?
      }

      json_hash[:client_id] = Client.for_user(@user).first.try(:id) if @user.client
      render :json => json_hash and return
    else
      render :json => {:success => false} and return
    end
  end
end
