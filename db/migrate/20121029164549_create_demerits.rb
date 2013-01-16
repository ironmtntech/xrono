class CreateDemerits < ActiveRecord::Migration
  def change
    create_table :demerits do |t|
      t.integer :user_id
      t.text :description
      t.boolean :resolved, :default => false
      t.timestamps
    end
  end
end
