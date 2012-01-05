require File.expand_path('../../../vendor/gems/gchart/lib/gchart', __FILE__)

class ApplicationController < ActionController::Base
  include RefurlHelper
  before_filter :initialize_site_settings
  before_filter :authenticate_user!, :except => [:payload]
  protect_from_forgery
  layout 'application'
  helper_method :redirect_to_ref_url, :admin?, :external_hours_chart_url
  rescue_from 'Acl9::AccessDenied', :with => :access_denied

  def build_week_hash_for(date, hash={})
    until date.saturday?
      day = date.strftime("%A")
      hash[day] = date
      date = date.tomorrow
    end
    return hash
  end

  def external_hours_chart_url(users, options = {})
    users = [users] unless users.is_a?(Array)
    return if @site_settings.client.nil?
    width       = options.fetch(:width, "450x120")
    chart_color = options.fetch(:chart_color, "F9F9F9")
    date        = options.fetch(:date, Time.zone.now)
    title       = options.fetch(:title, "")
    start_date, end_date = date.beginning_of_week.to_date, date.end_of_week.to_date
    internal_hours, external_hours = [],[]
    max_hours = 0
    (start_date..end_date).each do |i_date|
      _beg, _end = i_date.beginning_of_day, i_date.end_of_day
      bucket = WorkUnit.for_users(users).scheduled_between(_beg, _end)
      int = bucket.for_client(@site_settings.client).sum(:hours)
      ext = bucket.except_client(@site_settings.client).sum(:hours)
      internal_hours << int
      external_hours << ext
      max_hours = [max_hours, int, ext].max
    end
    GChart.bar(:title => title,
                         :orientation => :vertical,
                         :axis => [["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], [0, max_hours]],
                         :colors => ['ff0000', '00ff00'],
                         :size => width,
                         :data => [internal_hours,external_hours],
                         :legend => ["Int","Ext"],
                         :extras => {"chf" => "bg,s,00000000"} # Makes fill transparent
                         ).to_url
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
