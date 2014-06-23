class Admin::SurveysController < Admin::BaseController

  def index
    @surveys = Survey.all
  end
  
  def show
    @survey = Survey.find params[:id]
  end

  def create
    if params[:questions].present? && params[:project_id].present?
      @survey = Survey.new(params[:survey])
      if @survey.save
        params[:questions].each do |question|
          @survey.survey_questions.create(
            question: question[:question],
            min: question[:min],
            max: question[:max])
        end
        params[:project_id].each do |project_id|
          ProjectSurveyLink.create(project_id: project_id, survey_id: @survey.id)
        end
        flash[:notice] = 'Survey created!'
      end
    end
    redirect_to admin_survey_path(@survey)
  end

  def new
    @survey = Survey.new
  end
  
  def update
    if params[:questions].present? && params[:project_id].present?
      @survey = Survey.find params[:id]
      if @survey.update_attributes(params[:survey])
        params[:questions].each do |question|
          @survey.survey_questions.create(
            question: question[:question],
            min: question[:min],
            max: question[:max])
        end
        params[:project_id].each do |project_id|
          ProjectSurveyLink.create(project_id: project_id, survey_id: @survey.id)
        end
        flash[:notice] = 'Survey updated!'
      end
    end
    redirect_to admin_survey_path(@survey) 
  end

  def edit
    @survey = Survey.find params[:id]
  end

  def destroy
    @survey = Survey.find params[:id]
    if @survey.delete
      flash[:notice] = 'Survey was deleted.'
      redirect_to admin_surveys_path
    else
      flash[:error] = 'Survey could not be deleted.'
      redirect_to :back
    end
  end

  def add_question
    render :partial => "question_row"
  end

  def delete_question
    @survey_question = SurveyQuestion.find params[:id]
    if @survey_question.delete
      flash[:notice] = 'Question was deleted.'
    else
      flash[:error] = 'Question could not be deleted.'
    end
    redirect_to admin_survey_path(@survey_question.survey)
  end

end
