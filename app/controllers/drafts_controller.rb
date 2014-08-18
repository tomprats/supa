class DraftsController < ApplicationController
  before_filter :check_admin_level

  def index
    @teams = current_user.captains_teams
    @drafts = current_user.drafts
  end

  def show
    @draft = Draft.find(params[:id])
    @users = User.registered.select { |u| !u.drafted?(@draft.id) }

    if @draft.players_undrafted?
      if !@draft.order.empty?
        @groups = @draft.groups(current_user.id).order("created_at")
        @group = DraftGroup.new(draft_id: @draft.id, captain_id: current_user.id)
        @group.draft_players.build

        if @draft.drafted_players.last
          flash[:notice] = "#{@draft.drafted_players.first.name} has been drafted by #{@draft.drafted_players.first.team.name}: <a target=\"_blank\" href=\"#{feed_path(@draft.id)}\">View Feed</a>"
        end
      else
        redirect_to :back, notice: "Draft does not have a picking order yet"
      end
    else
      redirect_to captain_path, notice: "All the registered players have been drafted"
    end
  end

  def feed
    if params[:id]
      @draft = Draft.find(params[:id])
    else
      @draft = League.summer.draft
    end

    if !@draft.order.empty?
      @drafted_players = @draft.drafted_players
    else
      redirect_to :back, notice: "Draft does not have a picking order yet"
    end
  end

  def turn
    draft = Draft.find(params[:id])
    render json: { turn: draft.turn }
  end

  private
  def check_admin_level
    unless current_user.is_captain? || current_user.is_super_admin?
      redirect_to profile_path, notice: "You are not authorized to be there!"
    end
  end
end
