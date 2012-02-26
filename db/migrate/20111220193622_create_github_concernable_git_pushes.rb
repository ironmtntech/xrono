class CreateGithubConcernableGitPushes < ActiveRecord::Migration
  def change
    create_table :github_concernable_git_pushes do |t|
      t.string :github_concernable_type
      t.integer :github_concernable_id
      t.integer :git_push_id

      t.timestamps
    end
  end
end
