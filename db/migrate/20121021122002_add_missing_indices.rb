class AddMissingIndices < ActiveRecord::Migration
  def change
    add_index :contacts, :client_id
    add_index :data_vaults, [:data_vaultable_id, :data_vaultable_type], name: "dv_poly_vaultable"
    add_index :file_attachments, :client_id
    add_index :file_attachments, :ticket_id
    add_index :file_attachments, :project_id
    add_index :git_commits, :git_push_id
    add_index :git_pushes, :user_id
    add_index :github_concernable_git_pushes, [:github_concernable_id, :github_concernable_type], name: "gh_concern_poly"
    add_index :github_concernable_git_pushes, :git_push_id, name: 'gh_concern_push_id'
    add_index :projects, :client_id
    add_index :roles, [:authorizable_id, :authorizable_type], name: 'roles_auth'
    add_index :roles_users, :user_id
    add_index :roles_users, :role_id
    add_index :site_settings, :client_id
    add_index :taggings, [:tagger_id, :tagger_type], name: 'taggings_tagger'
    add_index :tickets, :project_id
    add_index :work_units, :ticket_id
  end
end
