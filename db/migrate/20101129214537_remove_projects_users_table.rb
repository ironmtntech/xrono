class RemoveProjectsUsersTable < ActiveRecord::Migration
  def self.up
    drop_table :projects_users
  end

  def self.down
    create_table :projects_users, :id => false do |t|
      t.references :project, :user
    end
  end
end
