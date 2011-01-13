class AddGuidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :guid, :string
  end

  def self.down
    remove_column :users, :guid
  end
end
