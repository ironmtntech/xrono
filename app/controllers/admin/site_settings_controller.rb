class Admin::SiteSettingsController < ApplicationController
  def edit
  end

  def update
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
