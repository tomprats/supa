class DraftPlayersController < ApplicationController
  before_filter :check_admin_level

  def create
    @draft_player = DraftPlayer.create(draft_group_params)
    redirect_to :back, :notice => "Draft Player successfully created."
  end

  def update
    @draft_player = DraftPlayer.find(params[:id])
    @draft_player.update(draft_group_params)
    redirect_to :back, :notice => "Draft Player successfully updated."
  end

  def destroy
    @draft_player = DraftPlayer.find(params[:id]).destroy
    redirect_to :back, :notice => "Draft Player successfully destroyed."
  end

  private
  def draft_player_params
    params.require(:draft_player).permit(:id,
                                         :player_id,
                                         :position,
                                         :rating,
                                         :info
                                        )
  end

  def check_admin_level
    case action_name
    when "create", "update", "destroy"
      if !current_user.is_captain?
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    end
  end
end
