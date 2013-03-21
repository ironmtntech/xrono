class Admin::BaseController < ApplicationController
  before_filter :require_admin
  helper :admin_base

  def index
  end

  def reports
  end

  protected
  def redirect_unless_monday(path_prefix, date)
    @start_date = date ? Date.parse(date) : Date.current
    unless @start_date.wday == 1 #Monday
      redirect_to(path_prefix + @start_date.beginning_of_week.strftime("%F"))
    end
  end
end
