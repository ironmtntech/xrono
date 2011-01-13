class AddSiteLogoColumnsToSiteSettings < ActiveRecord::Migration
  def self.up
    add_column :site_settings, :site_logo_file_name, :string
    add_column :site_settings, :site_logo_content_type, :string
    add_column :site_settings, :site_logo_file_size, :integer
    add_column :site_settings, :site_logo_updated_at, :datetime
  end

  def self.down
    remove_column :site_settings, :site_logo_updated_at
    remove_column :site_settings, :site_logo_file_size
    remove_column :site_settings, :site_logo_content_type
    remove_column :site_settings, :site_logo_file_name
  end
end
