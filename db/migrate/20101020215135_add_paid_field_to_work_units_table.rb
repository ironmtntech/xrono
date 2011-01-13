class AddPaidFieldToWorkUnitsTable < ActiveRecord::Migration
  def self.up
    add_column :work_units, :paid, :string
  end

  def self.down
    remove_column :work_units, :paid
  end
end
