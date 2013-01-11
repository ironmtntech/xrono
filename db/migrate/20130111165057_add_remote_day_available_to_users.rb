class AddRemoteDayAvailableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remote_day_available, :boolean
  end
end
