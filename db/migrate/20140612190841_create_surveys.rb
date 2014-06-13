class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :project_id

      t.timestamps
    end
  end
end
