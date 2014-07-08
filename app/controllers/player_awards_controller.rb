class PlayerAwardsController < ApplicationController
  def new
    if current_user.player_award
      redirect_to edit_player_award(current_user.player_award.id)
    else
      @players = User.registered.collect {|a| [a.name, a.id]}
      @females = User.registered.where(gender: :female).collect {|a| [a.name, a.id]}
      @captains = Team.active.collect { |t| [t.captain.name, t.captain.id] }
      @player_award = PlayerAward.new
    end
  end

  def create
    player_award = current_user.create_player_award(player_award_params)
    if player_award.errors.any?
      redirect_to :back, alert: player_award.errors.try(:messages).to_s
    else
      redirect_to profile_path, notice: "Player Awards created successfully"
    end
  end

  def edit
    @players = User.registered.collect {|a| [a.name, a.id]}
    @females = User.registered.where(gender: :female).collect {|a| [a.name, a.id]}
    @captains = Team.active.collect { |t| [t.captain.name, t.captain.id] }
    @player_award = current_user.player_award
  end

  def update
    player_award = current_user.player_award
    if player_award.update_attributes(player_award_params)
      redirect_to profile_path, notice: "Player Awards updated successfully"
    else
      redirect_to :back, alert: player_award.errors.try(:messages).to_s
    end
  end

  private
  def player_award_params
    params.require(:player_award).permit(
      :most_valuable,
      :offensive,
      :defensive,
      :rookie,
      :female,
      :comeback,
      :captain,
      :spirit,
      :iron_man,
      :most_outspoken,
      :most_improved,
      :hustle,
      :best_layouts,
      :most_underrated,
      :sportsmanship,
      :ideas
    )
  end
end
