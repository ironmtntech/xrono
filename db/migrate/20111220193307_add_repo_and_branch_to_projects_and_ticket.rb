class AddRepoAndBranchToProjectsAndTicket < ActiveRecord::Migration
  def change
    add_column :projects, :git_repo, :string
    add_column :tickets, :git_branch, :string
  end
end
