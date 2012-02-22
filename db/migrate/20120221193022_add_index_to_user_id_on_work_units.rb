class AddIndexToUserIdOnWorkUnits < ActiveRecord::Migration
  def change
    add_index :work_units, :user_id
  end
end
