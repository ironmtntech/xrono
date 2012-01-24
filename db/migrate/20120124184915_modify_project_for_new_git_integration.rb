class ModifyProjectForNewGitIntegration < ActiveRecord::Migration
  def up
    rename_column :projects, :git_repo, :git_repo_name
    add_column :projects, :git_repo_url, :string
  end

  def down
  end
end
