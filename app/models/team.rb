class Team < ActiveRecord::Base
  belongs_to              :league
  has_and_belongs_to_many :players, class_name: 'User'
  belongs_to              :captain, class_name: 'User'
  has_many                :team_stats
  has_many                :drafted_players
  accepts_nested_attributes_for :players

  validates_presence_of :name, :captain_id, :league_id

  def self.active
    where(league_id: League.current.id)
  end

  def wins
    games.select { |g| g.winner_id == id }
  end

  def losses
    games.select { |g| g.loser_id == id }
  end

  def games
    Game.all.select { |game| game.teams.include?(self) }
  end

  def place2
    hash = {}
    Game.active.each do |game|
      hash[game.winner_id] ||= {}
      hash[game.winner_id][game.loser_id] ||= 0
      hash[game.winner_id][game.loser_id] += 1
    end

    hash2 = hash.clone
    hash.each do |winner, losers|
      losers.each do |loser, total|
        hash2[loser] ||= {}
        hash2[loser][winner] ||= 0
        hash2[loser][winner] -= total
      end
    end

    binding.pry
  end

  def place
    "Coming Soon"
  end

  def points
    team_stats.active.inject(0){|sum,e| sum += e.goals.to_i }
  end

  def points_per_game
    team_stats.active.count.zero? ? 0 : points/team_stats.active.count
  end
end
