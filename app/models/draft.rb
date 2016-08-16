class Draft < ApplicationRecord
  has_many :drafted_players, dependent: :destroy
  has_many :tentative_players, dependent: :destroy
  belongs_to :league

  delegate :teams, to: :league

  def self.default_scope
    order(created_at: :desc)
  end

  def active?
    league.state == "Draft"
  end

  def captains
    teams.collect { |t| [t.captain, t.cocaptain] }.flatten.compact
  end

  def update_turn
    dp = drafted_players.find_by(player_id: nil)
    update_attributes(turn: dp.position) if dp
  end

  def my_turn?(user)
    team = current_pick.team
    [team.captain_id, team.cocaptain_id].include? user.id
  end

  def current_pick
    drafted_players.find_by(position: turn)
  end

  def players_undrafted?
    User.registered(league_id).count != drafted_players.where.not(player_id: nil).count
  end

  def update_players
    drafted_players.each do |dp|
      dp.team.players << dp.player unless dp.team.players.include? dp.player
    end
  end

  def setup_players
    drafted_players.update_all(player_id: nil)

    captains.each do |captain|
      team = captain.captains_team(league_id)
      dps = team.drafted_players.where(player_id: nil).to_a
      dps.shift.update(player_id: captain.id)

      captain.captains_team(league_id).players.each do |player|
        dps.shift.update(player_id: player.id)
      end
    end

    update_turn
  end
end
