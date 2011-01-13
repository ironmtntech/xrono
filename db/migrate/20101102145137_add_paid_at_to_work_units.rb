class AddPaidAtToWorkUnits < ActiveRecord::Migration
  def self.up
    add_column :work_units, :paid_at, :datetime
  end

  def self.down
    remove_column :work_units, :paid_at
  end
end
