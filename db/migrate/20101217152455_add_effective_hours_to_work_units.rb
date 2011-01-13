class AddEffectiveHoursToWorkUnits < ActiveRecord::Migration
  def self.up
    add_column :work_units, :effective_hours, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :work_units, :effective_hours
  end
end
