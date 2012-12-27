class AddLockableToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.datetime :locked_at
    end
  end

  def self.down
    remove_column :users, :locked_at
  end
end
