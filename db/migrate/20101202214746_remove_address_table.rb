class RemoveAddressTable < ActiveRecord::Migration
  def self.up
    drop_table :addresses
  end

  def self.down
    create_table :addresses do |t|
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state, :limit => 2
      t.string :zipcode
      t.references :addressable, :polymorphic => true
      t.timestamps
    end
  end
end
