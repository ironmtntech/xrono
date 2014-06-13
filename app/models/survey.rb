class Survey < ActiveRecord::Base

  #attr_accessible :project_id, :user_id

  has_many :survey_questions
  belongs_to :user

end
