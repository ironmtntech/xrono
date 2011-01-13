class RemoveCheckNumberFromWorkUnitsTable < ActiveRecord::Migration
  def self.up
    remove_column :work_units, :check_number
  end

  def self.down
    add_column :work_units, :check_number, :integer
  end
end
