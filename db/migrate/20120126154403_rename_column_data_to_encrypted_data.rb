class RenameColumnDataToEncryptedData < ActiveRecord::Migration
  def up
    rename_column :data_vaults, :data, :encrypted_data
  end

  def down
  end
end
