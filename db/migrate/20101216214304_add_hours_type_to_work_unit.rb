class AddHoursTypeToWorkUnit < ActiveRecord::Migration
  def self.up
    add_column :work_units, :hours_type, :string
  end

  def self.down
    remove_column :work_units, :hours_type
  end
end
