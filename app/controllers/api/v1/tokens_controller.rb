class Api::V1::TokensController < Api::V1::BaseController
  skip_before_filter :verify_authenticity_token

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
        :current_hours      => @user.unpaid_work_units.sum(:effective_hours),
        :pto_hours          => @user.pto_hours_left(Date.today.end_of_week),
        :offset             => @user.target_hours_offset(Date.today),
        :admin              => @user.admin?,
        :client             => @user.client?,
        :hours_graph_url    => external_hours_chart_url(@user)
      }
      Rails.logger.warn("Sending JSON")
      Rails.logger.warn(json_hash.to_json)
      render :json => json_hash and return
    else
      render :json => {:success => false} and return
    end
  end
end
