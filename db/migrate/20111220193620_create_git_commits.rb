class CreateGitCommits < ActiveRecord::Migration
  def change
    create_table :git_commits do |t|
      t.text :payload
      t.integer :git_push_id

      t.timestamps
    end
  end
end
