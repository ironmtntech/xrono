class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :email_address
      t.string  :phone_number
      t.integer :client_id

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
