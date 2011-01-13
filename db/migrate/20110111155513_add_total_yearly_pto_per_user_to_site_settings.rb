class AddTotalYearlyPtoPerUserToSiteSettings < ActiveRecord::Migration
  def self.up
    add_column :site_settings, :total_yearly_pto_per_user, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :site_settings, :total_yearly_pto_per_user
  end
end
