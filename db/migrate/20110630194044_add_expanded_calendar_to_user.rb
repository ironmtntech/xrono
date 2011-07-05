class AddExpandableToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :expandable, :boolean
  end

  def self.down
    remove_column :users, :expandable
  end
end
