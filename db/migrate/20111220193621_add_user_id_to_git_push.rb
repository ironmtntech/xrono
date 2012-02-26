class AddUserIdToGitPush < ActiveRecord::Migration
  def change
    add_column :git_pushes, :user_id, :integer
  end
end
