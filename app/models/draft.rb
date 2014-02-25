class Draft < ActiveRecord::Base
  has_many :draft_groups, :dependent => :destroy
  has_many :drafted_players, :dependent => :destroy

  serialize :order

  default_scope order('created_at DESC')

  def groups(captain)
    draft_groups.where(:captain_id => captain)
  end

  def players(captain)
    groups(captain).collect(&:draft_players).flatten
  end

  def teams
    Team.where("season = ? AND year = ?", season, year)
  end

  def captains
    teams.collect { |t| t.captain }
  end

  def round
    round_on(turn)
  end

  def round_on(turn_number)
    (turn_number / captains.count).floor + 1
  end

  def captains_turn
    whose_turn.name
  end

  def whose_turn
    whose_turn_on(turn)
  end

  def whose_turn_on(turn_number)
    index = (turn_number % order.count) - 1
    if index < 0
      index = order.count - 1
    end

    User.find(order[index])
  end

  def update_turn
    new_turn = turn + 1
    update_attributes(turn: new_turn)
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
        :team_id => captain.captains_team.id,
        :player_id => captain.id,
        :position => "Captain",
        :round => 0,
        :draft_id => id
      )

      captain.captains_team.players.each do |player|
        DraftedPlayer.create(
          :team_id => captain.captains_team.id,
          :player_id => player.id,
          :position => "Retainee",
          :round => 0,
          :draft_id => id
        )
      end
    end
  end

  def active?
    active
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
