class CreateWorkUnits < ActiveRecord::Migration
  def self.up
    create_table :work_units do |t|
      t.text :description
      t.integer :ticket_id

      t.timestamps
    end
  end

  def self.down
    drop_table :work_units
  end
end
