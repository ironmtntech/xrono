class AddLockableToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.lockable :lock_strategy => :none, :unlock_strategy => :none
    end
  end

  def self.down
    remove_column :users, :locked_at
  end
end
