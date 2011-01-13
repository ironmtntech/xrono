class AddUserToWorkUnits < ActiveRecord::Migration
  def self.up
    add_column :work_units, :user_id, :integer
  end

  def self.down
    remove_column :work_units, :user_id
  end
end
