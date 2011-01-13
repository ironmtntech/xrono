class RemovePaidAtFromWorkUnitsTable < ActiveRecord::Migration
  def self.up
    remove_column :work_units, :paid_at
  end

  def self.down
    add_column :work_units, :paid_at, :datetime
  end
end
