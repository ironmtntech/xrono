class AddInvoicedAtToWorkUnitsTable < ActiveRecord::Migration
  def self.up
    add_column :work_units, :invoiced_at, :datetime
  end

  def self.down
    remove_column :work_units, :invoiced_at
  end
end
