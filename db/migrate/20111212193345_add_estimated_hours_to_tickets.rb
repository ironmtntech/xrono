class AddEstimatedHoursToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :estimated_hours, :decimal, :precision => 10, :scale => 2
  end
end
