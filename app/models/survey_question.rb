class SurveyQuestion < ActiveRecord::Base

  #atrr_accessible :question, :survey_id, :base_question, :min, :max
 
  has_many :survey_answers
  belongs_to :survey

end
