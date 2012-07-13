class AddRatesToProject < ActiveRecord::Migration
  def change
    add_column :projects, :rate_a, :string
    add_column :projects, :rate_b, :string
  end
end
