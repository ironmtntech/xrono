class Admin::ShortDaysController < ApplicationController

  def index
    @short_day = ShortDay.new
    @users = User.all
  end

  def new
    @short_day = ShortDay.new
  end

  def create
    @distribution_manager = DistributionManager.new
    # need to build up the user with worked hours
    params[:hours].keys.each do |user_id|
      user = User.find user_id
      @distribution_manager.remove_hours_for_expected_hours(user, params[:hours][user_id])
    end
    redirect_to admin_short_days_path
  end
end
