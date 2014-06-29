class SurveyAnswer < ActiveRecord::Base

  #attr_accessible :survey_question_id, :answer, :user_id, :survey_id, :min,
  #:max
  #validates_numericality_of :answer, less_than_or_equal_to: :max, greater_than: :min
  
  belongs_to :survey
  belongs_to :survey_question
  belongs_to :user

end
