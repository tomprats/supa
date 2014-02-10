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
    (turn / captains.count).floor + 1
  end

  def captains_turn
    index = (turn % order.count) - 1
    if index < 0
      index = order.count - 1
    end

    captain_id = order[index]
    User.find(captain_id).name
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
