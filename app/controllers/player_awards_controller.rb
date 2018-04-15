class PlayerAwardsController < ApplicationController
  def new
    if current_user.player_award
      redirect_to edit_player_award_path(current_user.player_award.id)
    else
      set_form_data
      @player_award = PlayerAward.new
    end
  end

  def create
    return redirect_to edit_player_award_path(current_user.player_award.id) if current_user.player_award

    player_award = current_user.player_awards.create(player_award_params.merge!(league_id: League.current.id))
    if player_award.errors.any?
      redirect_back alert: player_award.errors.try(:messages).to_s
    else
      redirect_to profile_path, success: "Player Awards created successfully"
    end
  end

  def edit
    set_form_data
    @player_award = current_user.player_award
  end

  def update
    player_award = current_user.player_award
    if player_award.update_attributes(player_award_params)
      redirect_to profile_path, success: "Player Awards updated successfully"
    else
      redirect_back alert: player_award.errors.try(:messages).to_s
    end
  end

  private
  def player_award_params
    params.require(:player_award).permit(
      :most_valuable,
      :defensive,
      :rookie,
      :female,
      :captain,
      :spirit
    )
  end

  def set_form_data
    players = League.current.players
    @players = players.collect {|p| [p.name, p.id]}
    @females = players.where(gender: :female).collect {|p| [p.name, p.id]}
    season = League.where(season: League.current.season).pluck(:id)
    @rookies = Rails.cache.fetch("rookies_#{League.current.id}", expires_in: 3.hours) do
      players.select { |p|
        p.teams.where(league_id: season).count == 1
      }.collect {|p| [p.name, p.id]}
    end
    @captains = League.current.teams.collect { |t|
      [t.captain, t.cocaptain]
    }.flatten.compact.collect {|c| [c.name, c.id]}
  end
end
