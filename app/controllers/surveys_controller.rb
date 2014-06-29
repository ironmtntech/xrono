class SurveysController < ApplicationController

  def show
    @survey = Survey.find(params[:id])
    @survey_answer = SurveyAnswer.new
  end

  def create
    @survey = Survey.find params[:survey_answer][:survey_id]
    params[:questions].each do |question_id, answer|
      @survey_answer = SurveyAnswer.create(survey_question_id: question_id, answer: answer, user_id: current_user.id)
    end
    flash[:notice] = "Survey Completed!"
    redirect_to root_path
  end

end
