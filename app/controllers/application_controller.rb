class ApplicationController < ActionController::Base
  include RefurlHelper
  before_filter :initialize_site_settings
  before_filter :authenticate_user!
  protect_from_forgery
  layout 'application'
  helper_method :redirect_to_ref_url, :admin?
  rescue_from 'Acl9::AccessDenied', :with => :access_denied

  def build_week_hash_for(date, hash={})
    until date.saturday?
      day = date.strftime("%A")
      hash[day] = date
      date = date.tomorrow
    end
    return hash
  end

  def log_fnord_event(options)
    uuid = UUID.generate
    redis = Redis.new

    if current_user
      user = current_user
      options["_session"] = user.id.to_s
      log_fnord_user(user) unless options.delete(:skip_user_logging)
    end

    event = options.to_json

    redis.set("fnordmetric-event-#{uuid}", event)
    redis.expire("fnordmetric-event-#{uuid}", 60)
    redis.lpush("fnordmetric-queue", uuid)
  end

  def log_fnord_user(user)
    log_fnord_event(_type: '_set_name', name: user.email, skip_user_logging: true)
    log_fnord_event(_type: '_set_picture', url: user.gravatar_url, skip_user_logging: true)
  end

  private

  def redirect_unless_monday(path_prefix, date)
    @start_date = date ? Date.parse(date) : Date.current
    unless @start_date.monday?
      redirect_to(path_prefix + @start_date.beginning_of_week.strftime("%F"))
    end
  end

  def require_admin
    unless current_user && current_user.admin?
      flash[:error] = t(:you_must_be_an_admin_to_do_that)
      redirect_to root_path
    end
  end

  def admin?
    current_user && current_user.admin?
  end

  def access_denied
    flash[:notice] = 'Access denied.'
    if current_user && current_user.client
      redirect_to client_login_path
    else
      redirect_to root_path
    end
  end

  def initialize_site_settings
    @site_settings = SiteSettings.first ? SiteSettings.first : SiteSettings.create(:total_yearly_pto_per_user => 40, :overtime_multiplier => 1.5)
  end

  def redirect_clients
    if current_user && current_user.client
      redirect_to client_login_path unless current_user.admin?
    end
  end
end
