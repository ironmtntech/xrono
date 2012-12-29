class Xrono::ApplicationController < ActionController::Base
  include RefurlHelper
  helper Xrono.helpers
  layout 'application'
  protect_from_forgery

  before_filter :initialize_site_settings
  before_filter :redirect_clients
  before_filter :authenticate_user!, :except => [:payload]
  helper_method :redirect_to_ref_url, :admin?, :client?, :external_hours_for_chart
  rescue_from 'Acl9::AccessDenied', :with => :access_denied

  def get_calendar_details
    if params[:date].present? && params[:date] != "null"
      @start_date = Date.parse(params[:date]).beginning_of_week
    else
      @start_date = Date.current.beginning_of_week
    end
  end

  private
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
    if client?
      redirect_to client_login_clients_path
    else
      redirect_to root_path
    end
  end

  def initialize_site_settings
    @site_settings = SiteSettings.first || SiteSettings.create(site_settings_defaults)
  end

  def redirect_clients
    return if params[:controller] == "devise/sessions"
    if client?
      redirect_to client_login_clients_path unless admin?
    end
  end

  def get_tag_list_for(array)
    array.join(",")
  end

  protected
  def site_settings_defaults
    { :total_yearly_pto_per_user => BigDecimal('40'), :overtime_multiplier => BigDecimal('1.5') }
  end
end
