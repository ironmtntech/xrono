class AddActiveToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :active, :boolean
  end

  def self.down
    remove_column :comments, :active
  end
end
