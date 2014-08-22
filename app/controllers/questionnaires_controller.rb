class QuestionnairesController < ApplicationController
  before_filter :check_admin_level, only: :show

  def show
    @questionnaire = Questionnaire.find(params[:id])
  end

  def create
    if Questionnaire.create(questionnaire_params).valid?
      redirect_to :back, notice: "Thanks for filling out the questionnaire"
    else
      redirect_to :back, alert: "Questionnaire could not be created"
    end
  end

  def update
    if Questionnaire.find(params[:id]).update_attributes(questionnaire_params)
      redirect_to :back, notice: "Thanks for filling out the questionnaire"
    else
      redirect_to :back, alert: "Questionnaire could not be updated"
    end
  end

  private
  def check_admin_level
    unless current_user.is_captain? || current_user.is_real_admin?
      redirect_to profile_path, notice: "You are not authorized to be there!"
    end
  end

  def questionnaire_params
    if params[:questionnaire][:meetings_attributes]
      meetings = params[:questionnaire][:meetings_attributes].collect do |m|
        m[1][:datetime] = convert_to_datetime(m[1].delete(:date), m[1].delete(:time))
        m[1]
      end
      params[:questionnaire][:meetings_attributes] = meetings
    end

    params.require(:questionnaire).permit(
      :handling,
      :cutting,
      :defense,
      :fitness,
      :injuries,
      :height,
      :teams,
      :cocaptain,
      :comments,
      :handler,
      :cutter,
      :league_id,
      :user_id,
      meetings_attributes: [:id, :datetime, :available]
    )
  end

  def convert_to_datetime(date, time)
    DateTime.strptime("#{date} #{time}", "%m/%d/%Y %I:%M %p") if !date.blank? && !time.blank?
  end
end
