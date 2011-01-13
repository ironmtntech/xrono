class AddRecievesEmailToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :recieves_email, :boolean, :default => false
  end

  def self.down
    remove_column :contacts, :recieves_email
  end

end
