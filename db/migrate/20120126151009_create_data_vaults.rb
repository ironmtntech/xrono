class CreateDataVaults < ActiveRecord::Migration
  def change
    create_table :data_vaults do |t|
      t.integer :data_vaultable_id
      t.string :data_vaultable_type
      t.text :data

      t.timestamps
    end
  end
end
