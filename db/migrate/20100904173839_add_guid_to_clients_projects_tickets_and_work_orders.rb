class AddGuidToClientsProjectsTicketsAndWorkOrders < ActiveRecord::Migration
  def self.up
    [:clients, :projects, :tickets, :work_units].each do |key|
      add_column key, :guid, :string
    end
  end

  def self.down
    [:clients, :projects, :tickets, :work_units].each do |key|
      remove_column key, :guid
    end
  end
end
