class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer :project_id
      t.string :priority
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
