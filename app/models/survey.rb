class Survey < ActiveRecord::Base

  attr_accessible :project_id

  has_many :survey_questions
  belongs_to :user
  has_many :project_survey_links
  has_many :projects, :through => :project_survey_links

  def questions
    survey_questions
  end

end
