class CreateSurveyQuestions < ActiveRecord::Migration
  def change
    create_table :survey_questions do |t|
      t.integer :survey_id
      t.string  :question
      t.integer :min
      t.integer :max
      t.boolean :base_question

      t.timestamps
    end
  end
end
