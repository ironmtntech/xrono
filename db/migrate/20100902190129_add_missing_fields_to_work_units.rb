class AddMissingFieldsToWorkUnits < ActiveRecord::Migration
  def self.up
    add_column :work_units, :hours, :decimal, :precision => 10, :scale => 2
    add_column :work_units, :overtime, :boolean
    add_column :work_units, :scheduled_at, :datetime
  end

  def self.down
    remove_column :work_units, :scheduled_at
    remove_column :work_units, :overtime
    remove_column :work_units, :hours
  end
end
