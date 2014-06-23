class ProjectSurveyLink < ActiveRecord::Base
  #attr_accessible :project_id, :survey_id
  
  belongs_to :project
  belongs_to :survey

end
