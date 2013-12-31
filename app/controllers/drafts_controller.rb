class DraftsController < ApplicationController
  before_filter :check_admin_level

  def new
    @draft = Draft.new
  end

  def create
    @draft = Draft.create(draft_params)
    redirect_to :back, :notice => "Draft successfully created."
  end

  def show
    @draft = Draft.find(params[:id])

    if @draft.drafted_players.empty?
      @draft.captains.each do |captain|
        DraftedPlayer.create(
          :team_id => captain.captains_team.id,
          :player_id => captain.id,
          :position => "Captain",
          :round => 0,
          :draft_id => @draft.id
        )

        captain.captains_team.players.each do |player|
          DraftedPlayer.create(
            :team_id => captain.captains_team.id,
            :player_id => player.id,
            :position => "Retained",
            :round => 0,
            :draft_id => @draft.id
          )
        end
      end
    end

    if @draft.order
      @groups = @draft.groups(current_user.id).order("created_at")
      @group = DraftGroup.new(:draft_id => @draft.id,
                              :captain_id => current_user.id)
      @group.draft_players.build
    else
      redirect_to :back, :notice => "Draft does not have a picking order yet"
    end
  end

  def index
    @teams = current_user.captains_teams
    @drafts = current_user.drafts
  end

  def edit
    @draft = Draft.find(params[:id])
  end

  def update
    @draft = Draft.find(params[:id])
    @draft.update(draft_params)
    redirect_to :back, :notice => "Draft successfully updated."
  end

  def destroy
    @draft = Draft.find(params[:id]).destroy
    redirect_to :back, :notice => "Draft successfully destroyed."
  end

  def order
    draft = Draft.find(params[:id])
    order = params[:order].collect { |o| o.last.to_i }
    if order.length == order.uniq.length
      draft.update_attributes(:order => order)
      redirect_to :back, :notice => "Draft order successfully updated."
    else
      redirect_to :back, :alert => "Draft order could not be updated."
    end
  end

  def turn
    draft = Draft.find(params[:id])
    render :json => { :turn => draft.turn }
  end

  private
  def draft_params
    params.require(:draft).permit(:season,
                                  :year,
                                  :active)
  end

  def check_admin_level
    case action_name
    when "new", "create", "edit", "update", "destroy"
      if current_user.admin != "super"
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    when "show", "index"
      if !current_user.is_captain?
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    end
  end
end
