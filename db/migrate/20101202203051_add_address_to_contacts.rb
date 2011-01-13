class AddAddressToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :street, :string
    add_column :contacts, :city, :string
    add_column :contacts, :state, :string
    add_column :contacts, :zip, :string
    add_column :contacts, :county, :string
    add_column :contacts, :country, :string
  end

  def self.down
    remove_column :contacts, :street
    remove_column :contacts, :city
    remove_column :contacts, :state
    remove_column :contacts, :zip
    remove_column :contacts, :county
    remove_column :contacts, :country
  end
end
