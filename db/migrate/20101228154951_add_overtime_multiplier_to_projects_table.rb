class AddOvertimeMultiplierToProjectsTable < ActiveRecord::Migration
  def self.up
    add_column :projects, :overtime_multiplier, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :projects, :overtime_multiplier
  end
end
