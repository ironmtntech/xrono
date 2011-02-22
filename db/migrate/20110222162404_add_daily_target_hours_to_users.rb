class AddDailyTargetHoursToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :daily_target_hours, :integer
  end

  def self.down
    remove_column :users, :daily_target_hours
  end
end
