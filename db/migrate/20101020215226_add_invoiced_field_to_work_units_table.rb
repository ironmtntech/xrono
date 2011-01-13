class AddInvoicedFieldToWorkUnitsTable < ActiveRecord::Migration
  def self.up
    add_column :work_units, :invoiced, :string
  end

  def self.down
    remove_column :work_units, :invoiced
  end
end
