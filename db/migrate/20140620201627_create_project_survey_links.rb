class CreateProjectSurveyLinks < ActiveRecord::Migration
  def change
    create_table :project_survey_links do |t|
      t.integer :project_id
      t.integer :survey_id

      t.timestamps
    end
  end
end
