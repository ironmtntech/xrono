class ApplicationController < ActionController::Base
  include RefurlHelper
  before_filter :initialize_site_settings
  before_filter :redirect_clients
  before_filter :authenticate_user!, :except => [:payload]
  protect_from_forgery
  layout 'application'
  helper_method :redirect_to_ref_url, :admin?, :external_hours_for_chart, :client?
  rescue_from 'Acl9::AccessDenied', :with => :access_denied

  def get_calendar_details
    if params[:date].present? && params[:date] != "null"
      @start_date = Date.parse(params[:date]).beginning_of_week
    else
      @start_date = Date.current.beginning_of_week
    end
  end

  def build_week_hash_for(date, hash={})
    until date.wday == 0 #Sunday
      day = date.strftime("%A")
      hash[day] = date
      date = date.tomorrow
    end
    return hash
  end

  def external_hours_for_chart(users, options = {})
    users                 = Array(users)
    date                  = options.fetch(:date, Time.zone.now)
    start_date, end_date  = date.beginning_of_week.to_date, date.end_of_week.to_date

    final_array = []
    (start_date..end_date).each do |i_date|
      _beg, _end = i_date.beginning_of_day, i_date.end_of_day
      hours = WorkUnit.for_users(users).scheduled_between(_beg,_end).all
      final_array << [i_date.strftime("%a"), sum_hours(:external?, hours).to_f, sum_hours(:internal?, hours).to_f]
    end
    final_array
  end

  private
  def sum_hours(method, hours)
    hours.select{|wu| wu.send(method) }.sum(&:hours)
  end

  def redirect_unless_monday(path_prefix, date)
    @start_date = date ? Date.parse(date) : Date.current
    unless @start_date.wday == 1 #Monday
      redirect_to(path_prefix + @start_date.beginning_of_week.strftime("%F"))
    end
  end

  def require_admin
    unless admin?
      flash[:error] = t(:you_must_be_an_admin_to_do_that)
      redirect_to root_path
    end
  end

  def admin?
    current_user && current_user.admin?
  end

  def client?
    current_user && current_user.client?
  end

  def access_denied
    flash[:notice] = 'Access denied.'
    if current_user && current_user.client?
      redirect_to client_login_clients_path
    else
      redirect_to root_path
    end
  end

  def initialize_site_settings
    @site_settings = SiteSettings.first ? SiteSettings.first : SiteSettings.create(:total_yearly_pto_per_user => BigDecimal('40'), :overtime_multiplier => BigDecimal('1.5'))
  end

  def redirect_clients
    return if params[:controller] == "devise/sessions"
    if current_user && current_user.client?
      redirect_to client_login_clients_path unless current_user.admin?
    end
  end

  def get_tag_list_for(array)
    array.join(",")
  end
end
