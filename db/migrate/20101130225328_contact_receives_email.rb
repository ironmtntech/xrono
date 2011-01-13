class ContactReceivesEmail < ActiveRecord::Migration
  def self.up
    rename_column :contacts, :recieves_email, :receives_email
  end

  def self.down
    rename_column :contacts, :receives_email, :recieves_email
  end
end
