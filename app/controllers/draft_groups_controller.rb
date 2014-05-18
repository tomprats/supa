class DraftGroupsController < ApplicationController
  before_filter :check_admin_level

  def create
    params[:draft_group][:draft_players_attributes].each do |dp|
      if dp.last[:player_id] == ""
        params[:draft_group][:draft_players_attributes].delete dp.first
      end
    end
    @draft_group = DraftGroup.create(draft_group_params)

    redirect_to :back, notice: "Draft Group successfully created."
  end

  def update
    @draft_group = DraftGroup.find(params[:id])
    params[:draft_group][:draft_players_attributes].each do |dp|
      if dp.last[:player_id] == ""
        params[:draft_group][:draft_players_attributes].delete dp.first
      end
    end

    @draft_group.update(draft_group_params)
    redirect_to :back, notice: "Draft Group successfully updated."
  end

  def destroy
    @draft_group = DraftGroup.find(params[:id]).destroy
    redirect_to :back, notice: "Draft Group successfully destroyed."
  end

  private
  def draft_group_params
    params.require(:draft_group).permit(
      :name,
      :draft_id,
      :captain_id,
      draft_players_attributes: [
        :_destroy,
        :id,
        :player_id,
        :position,
        :rating,
        :info
      ]
    )
  end

  def check_admin_level
    case action_name
    when "create", "update"
      if current_user.id != params[:draft_group][:captain_id].to_i
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    when "destroy"
      if current_user != DraftGroup.find(params[:id]).captain
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    end
  end
end
