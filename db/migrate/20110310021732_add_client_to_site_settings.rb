class AddClientToSiteSettings < ActiveRecord::Migration
  def self.up
    add_column :site_settings, :client_id, :integer
  end

  def self.down
    remove_column :site_settings, :client_id
  end
end
