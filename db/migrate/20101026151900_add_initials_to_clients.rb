class AddInitialsToClients < ActiveRecord::Migration
  def self.up
    add_column :clients, :initials, :string
  end

  def self.down
    remove_column :clients, :initials
  end
end
