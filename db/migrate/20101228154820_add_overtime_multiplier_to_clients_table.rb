class AddOvertimeMultiplierToClientsTable < ActiveRecord::Migration
  def self.up
    add_column :clients, :overtime_multiplier, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :clients, :overtime_multiplier
  end
end
