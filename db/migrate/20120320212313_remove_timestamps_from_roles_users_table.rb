class RemoveTimestampsFromRolesUsersTable < ActiveRecord::Migration
  def up
    remove_column :roles_users, :created_at
    remove_column :roles_users, :updated_at
  end

  def down
    add_column :roles_users, :created_at, :datetime, :null => false
    add_column :roles_users, :updated_at, :datetime, :null => false
  end
end
