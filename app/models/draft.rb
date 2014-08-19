class Draft < ActiveRecord::Base
  has_many :drafted_players, dependent: :destroy
  has_many :tentative_players, dependent: :destroy
  belongs_to :league

  delegate :teams, to: :league

  serialize :order, Array

  def self.default_scope
    order('created_at DESC')
  end

  def players(captain)
    groups(captain).collect(&:draft_players).flatten
  end

  def captains
    teams.collect { |t| t.captain }
  end

  def round
    round_on(turn)
  end

  def round_on(turn_number)
    ((turn_number - 1) / captains.count).floor + 1
  end

  def captains_turn
    whose_turn.name
  end

  def whose_turn
    whose_turn_on(turn)
  end

  def whose_turn_on(turn_number)
    if order.count != 0
      index = (turn_number % order.count) - 1
      if index < 0
        index = order.count - 1
      end

      User.find(order[index])
    else
      nil
    end
  end

  def update_turn
    if snake? && turn % order.count <= 0
      update_attributes(order: order.reverse)
    end
    update_attributes(turn: turn + 1)
  end

  def update_players
    drafted_players.each do |dp|
      dp.team.players << dp.player
    end
  end

  def setup_players
    update_attributes(turn: 1)
    drafted_players.destroy_all

    captains.each do |captain|
      DraftedPlayer.create(
        team_id: captain.captains_team(league_id).id,
        player_id: captain.id,
        position: "Captain",
        round: 0,
        draft_id: id
      )

      captain.captains_team(league_id).players.each do |player|
        DraftedPlayer.create(
          team_id: captain.captains_team(league_id).id,
          player_id: player.id,
          position: "Retainee",
          round: 0,
          draft_id: id
        )
      end
    end
  end

  def active?
    active
  end

  def snake?
    snake
  end

  def my_turn?(current_user)
    captains_turn == current_user.name
  end

  def players_undrafted?
    User.registered.each do |player|
      return true if !player.drafted?(id)
    end
    false
  end
end
