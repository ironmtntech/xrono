class AddCheckNumberToWorkUnitsTable < ActiveRecord::Migration
  def self.up
    add_column :work_units, :check_number, :integer
  end

  def self.down
    remove_column :work_units, :check_number
  end
end
