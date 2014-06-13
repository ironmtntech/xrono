class SurveyAnswer < ActiveRecord::Base

  attr_accessible :survey_question_id, :answer, :user_id, :survey_id
  
  belongs_to :survey
  belongs_to :survey_question
  belongs_to :user

end
