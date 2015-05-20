class Team < ActiveRecord::Base
  belongs_to              :league
  has_and_belongs_to_many :players, class_name: 'User'
  belongs_to              :captain, class_name: 'User'
  belongs_to              :cocaptain, class_name: 'User'
  has_many                :team_stats
  has_many                :drafted_players
  has_many                :tentative_players
  accepts_nested_attributes_for :players

  validates_presence_of :name, :captain_id, :league_id

  def wins
    games.select { |g| g.winner_id == id }
  end

  def losses
    games.select { |g| g.loser_id == id }
  end

  def ties
    games.select { |g| g.tie? }
  end

  def games
    Game.all.select { |game| game.teams.include?(self) }
  end

  def self.collection_with_leagues
    League.all.collect(&:teams).flatten.collect{ |t| ["#{t.league.name}: #{t.name}", t.id] }
  end

  def points
    team_stats.active.inject(0){|sum,e| sum += e.goals.to_i }
  end

  def points_against
    sum = 0
    team_stats.active.each do |ts|
      return "Unknown" unless ts.game
      if ts.game.team_stats1.team_id != id
        ts_against = ts.game.team_stats1
      else
        ts_against = ts.game.team_stats2
      end
      sum += ts_against.goals.to_i
    end
    sum
  end

  def point_differential
    return "Unknown" if points_against == "Unknown"
    points - points_against
  end

  def points_per_game
    team_stats.active.count.zero? ? 0 : points/team_stats.active.count
  end
end
