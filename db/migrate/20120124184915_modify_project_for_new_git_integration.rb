class ModifyProjectForNewGitIntegration < ActiveRecord::Migration
  def up
    rename_column :projects, :git_repo, :git_repo_name
    add_column :projects, :git_repo_url, :string
    add_column :projects, :release_notes, :text
    add_column :projects, :xrono_notes, :text
  end

  def down
  end
end
