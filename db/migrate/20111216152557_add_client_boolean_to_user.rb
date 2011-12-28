class AddClientBooleanToUser < ActiveRecord::Migration
  def change
    add_column :users, :client, :boolean, :default => 0
  end
end
