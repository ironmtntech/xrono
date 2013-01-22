class Admin::SiteSettingsController < ApplicationController
  def edit
    @short_days = ShortDay.all
  end

  def update
    if  params[:short_day_date].present? && params[:short_day_hours].present?
      ShortDay.create(:date => params[:short_day_date], :hours => params[:short_day_hours].to_i)
      @distribution_manager = DistributionManager.new
      @distribution_manager.issue_hours_for_short_days(8 - params[:short_day_hours].to_i)
    end
    if @site_settings.update_attributes(params[:admin_site_settings])
      flash[:notice] = t(:site_settings_updated_successfully)
      redirect_to :back
    end
  end

  def destroy
    @site_settings.site_logo.destroy
    if @site_settings.save
      flash[:notice] = t(:site_logo_removed_successfully)
      redirect_to edit_admin_site_settings_path
    end
  end
end
