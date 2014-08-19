module Captain
  class TentativePlayersController < ApplicationController
    before_filter :check_admin_level

    def create
      league_id = Draft.find(params[:tentative_player][:draft_id]).league_id
      @draft_player = TentativePlayer.create(
        tentative_player_params.merge!(team_id: current_user.captains_team(league_id).id)
      )
      redirect_to :back, notice: "Tentative Player successfully created."
    end

    def destroy
      @draft_player = TentativePlayer.find(params[:id]).destroy
      redirect_to :back, notice: "Tentative Player successfully destroyed."
    end

    private
    def tentative_player_params
      params.require(:tentative_player).permit(
        :draft_id,
        :player_id,
        :info
      )
    end

    def check_admin_level
      unless current_user.is_captain?
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    end
  end
end
