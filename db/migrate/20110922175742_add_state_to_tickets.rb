class AddStateToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :state, :string
  end

  def self.down
    remove_column :tickets, :state
  end
end
