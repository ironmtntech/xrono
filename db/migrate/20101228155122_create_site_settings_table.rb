class CreateSiteSettingsTable < ActiveRecord::Migration
  def self.up
    create_table :site_settings do |t|
      t.decimal :overtime_multiplier, :precision => 10, :scale => 2
    end
  end

  def self.down
    drop_table :site_settings
  end
end
