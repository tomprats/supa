module Super
  class DraftsController < ApplicationController
    before_filter :check_admin_level

    def index
      @drafts = Draft.all
    end

    def create
      @draft = Draft.create(draft_params)
      redirect_to super_drafts_path, success: "Draft successfully created."
    end

    def edit
      @draft = Draft.find(params[:id])
    end

    def update
      @draft.update(draft_params)
      redirect_to super_drafts_path, success: "Draft successfully updated."
    end

    def reset
      @draft = Draft.find(params[:id])
      @draft.setup_players
      redirect_to super_drafts_path, success: "Draft successfully reset."
    end

    def destroy
      @draft = Draft.find(params[:id]).destroy
      redirect_to super_drafts_path, success: "Draft successfully destroyed."
    end

    def order
      @draft = Draft.find(params[:id])
      @teams = @draft.teams
      @players = @draft.drafted_players
      @registered = User.registered(@draft.league_id).count
    end

    def update_order
      draft = Draft.find(params[:id])
      picks = Hash[draft.teams.collect { |t| [t.id, t.drafted_players.to_a] }]
      order = params[:picks].collect { |p| p.to_i }
      order.each_with_index do |pick, index|
        index = index + 1
        drafted_player = picks[pick].shift
        if drafted_player
          drafted_player.update(position: index)
        else
          DraftedPlayer.create(
            draft_id: draft.id,
            team_id: pick,
            position: index
          )
        end
      end

      picks.each do |key, value|
        value.each { |dp| dp.destroy }
      end

      render json: { success: true }
    end

    private
    def check_admin_level
      unless current_user.is_super_admin?
        redirect_to profile_path, success: "You are not authorized to be there!"
      end
    end

    def draft_params
      params.require(:draft).permit(:league_id)
    end
  end
end
