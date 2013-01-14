class CreateRemoteWorkdayRequests < ActiveRecord::Migration
  def change
    create_table :remote_workday_requests do |t|
      t.integer :user_id
      t.text :description
      t.date :date_requested
      t.string :state

      t.timestamps
    end
  end
end
