class Admin::SurveysController < Admin::BaseController

  def index
    @surveys = Survey.all
  end
  
  def show
    @survey = Survey.find params[:id]
  end

  def create
    @survey = Survey.new(params[:survey])
    if @survey.save
      if params[:questions].present?
        params[:questions].each do |question|
          @survey.survey_questions.create(
            question: question[:question],
            min: question[:min],
            max: question[:max])
        end
      end
    end
    flash[:notice] = 'Survey created'
    redirect_to admin_survey_path(@survey)
  end

  def new
    @survey = Survey.new
  end
  
  def update
    @survey = Survey.find params[:id]
  end

  def edit
    @survey = Survey.find params[:id]
  end

  def delete_question
    @question = Question.find params[:id]
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

end
