class AddExpandedCalendarToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :expanded_calendar, :boolean
  end

  def self.down
    remove_column :users, :expandable
  end
end
