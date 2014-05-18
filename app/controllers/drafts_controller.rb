class DraftsController < ApplicationController
  before_filter :check_admin_level
  skip_before_filter :authenticate_user!, :check_attr, only: [:feed]

  def new
    @draft = Draft.new
  end

  def create
    @draft = Draft.create(draft_params)
    redirect_to :back, notice: "Draft successfully created."
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

  def activate
    draft = Draft.find(params[:id])
    draft.setup_players
    if draft.update_attributes(active: params[:active])
      redirect_to :back, notice: "Draft has been updated"
    else
      redirect_to :back, alert: "Draft cannot be updated"
    end
  end

  def snake
    draft = Draft.find(params[:id])
    if draft.update_attributes(snake: params[:snake])
      redirect_to :back, notice: "Draft has been updated"
    else
      redirect_to :back, alert: "Draft cannot be updated"
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
    @draft.update(draft_params)
    redirect_to :back, notice: "Draft successfully updated."
  end

  def destroy
    @draft = Draft.find(params[:id]).destroy
    redirect_to :back, notice: "Draft successfully destroyed."
  end

  def order
    draft = Draft.find(params[:id])
    order = params[:order].collect { |o| o.last.to_i }
    if order.length == order.uniq.length
      draft.update_attributes(order: order)
      redirect_to :back, notice: "Draft order successfully updated."
    else
      redirect_to :back, alert: "Draft order could not be updated."
    end
  end

  def turn
    draft = Draft.find(params[:id])
    render json: { turn: draft.turn }
  end

  private
  def draft_params
    params.require(:draft).permit(:league_id, :active)
  end

  # Not used for turn or feed
  def check_admin_level
    case action_name
    when "new", "create", "edit", "update", "destroy"
      if current_user.admin != "super"
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    when "show", "index"
      if !current_user.is_captain?
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    end
  end
end
