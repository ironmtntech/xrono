class CreateGitPushes < ActiveRecord::Migration
  def change
    create_table :git_pushes do |t|
      t.text :payload

      t.timestamps
    end
  end
end
