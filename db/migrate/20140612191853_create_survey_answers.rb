class CreateSurveyAnswers < ActiveRecord::Migration
  def change
    create_table :survey_answers do |t|
      t.integer :survey_question_id
      t.integer :survey_id
      t.integer :answer
      t.integer :user_id

      t.timestamps
    end
  end
end
