class QuestionnairesController < ApplicationController
  before_action :check_admin_level, only: :show
  skip_before_action :check_attr

  def show
    @questionnaire = Questionnaire.find(params[:id])
  end

  def create
    if Questionnaire.create(questionnaire_params).valid?
      save_baggage
      redirect_back success: "Thanks for filling out the questionnaire"
    else
      redirect_back alert: "Questionnaire could not be created"
    end
  end

  def update
    if Questionnaire.find(params[:id]).update_attributes(questionnaire_params)
      save_baggage
      redirect_back success: "Thanks for filling out the questionnaire"
    else
      redirect_back alert: "Questionnaire could not be updated"
    end
  end

  private
  def check_admin_level
    unless current_user.is_captain? || current_user.is_real_admin?
      redirect_to profile_path, success: "You are not authorized to be there!"
    end
  end

  def save_baggage
    partner_id = params[:baggage][:partner_id]
    return if partner_id.blank?
    league_id = params[:questionnaire][:league_id]
    comment = params[:baggage][:comment]
    baggage = Baggage.find_by_partners(current_user.id, partner_id, league_id)
    if baggage
      baggage.add_comment(current_user.id, comment)
    else
      Baggage.create(
        league_id: league_id,
        partner1_id: current_user.id,
        partner2_id: partner_id,
        comment1: comment
      )
    end
  end

  def questionnaire_params
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
      meetings_attributes: [:id, :event_id, :available]
    )
  end
end
