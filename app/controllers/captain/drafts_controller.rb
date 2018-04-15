module Captain
  class DraftsController < ApplicationController
    before_action :check_admin_level

    def index
      @teams = current_user.captains_teams
      @drafts = current_user.drafts
    end

    def show
      @draft = Draft.find(params[:id])
      @users = User.registered(@draft.league_id).select { |u| !u.drafted?(@draft.id) }
      @tentative_players = current_user.captains_team(@draft.league_id).tentative_players
      @drafted_players = current_user.captains_team(@draft.league_id).drafted_players
      @baggage = Baggage.where(league_id: @draft.league_id, approved: true)
      @users_with_baggage = @users.collect do |user|
        name = user.name
        if baggage = @baggage.find { |b| [b.partner1_id, b.partner2_id].include? user.id }
          partner = baggage.other_partner(user.id)
          if partner.registered?(@draft.league_id) && !partner.drafted?(@draft.id)
            name += " (#{partner.name})"
          end
        end
        [name, user.id]
      end

      if @draft.players_undrafted?
        @draft.setup_players if @drafted_players.where.not(player_id: nil).empty? && @draft.active?

        @drafted_players = current_user.captains_team(@draft.league_id).drafted_players
        @last = @drafted_players.where.not(player_id: nil).last
        if flash.empty? && @last
          flash[:success] = "#{@last.name} has been drafted by #{@last.team.name}: <a target=\"_blank\" href=\"#{feed_draft_path(@draft.id)}\">View Feed</a>"
        end
      else
        @first = @draft.teams.first
        @draft.update_players unless @first.drafted_players.count == @first.players.count
        redirect_to captain_path, success: "All the registered players have been drafted"
      end
    end

    private
    def check_admin_level
      unless current_user.is_captain? || current_user.is_super_admin?
        redirect_to profile_path, danger: "You are not authorized to be there!"
      end
    end
  end
end
