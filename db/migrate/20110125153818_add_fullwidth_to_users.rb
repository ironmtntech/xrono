class AddFullwidthToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :full_width, :boolean, :default => false
  end

  def self.down
    remove_column :users, :full_width
  end
end
