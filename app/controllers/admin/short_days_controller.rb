class Admin::ShortDaysController < ApplicationController

  def index
    @short_days = ShortDay.all
  end

  def new
    @short_day = ShortDay.new
  end

  def create
    @short_day = ShortDay.new(params[:short_day])
    if @short_day.save
      @distribution_manager = DistributionManager.new
      @distribution_manager.issue_hours_for_short_days(8 - params[:short_day_hours].to_i)
      redirect_to admin_short_days_path
    else
      render :new
    end
 
  end
end
