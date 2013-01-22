class CreateShortDays < ActiveRecord::Migration
  def up
    create_table :short_days do |t|
      t.date :date
      t.integer :hours
      t.timestamps
    end
  end

  def down
    drop_table :short_days
  end
end
