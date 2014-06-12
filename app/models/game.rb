class Game < ActiveRecord::Base
  belongs_to :league
  belongs_to :field
  belongs_to :winner,   class_name: "Team"
  belongs_to :loser,    class_name: "Team"
  belongs_to :creator,  class_name: "User"
  belongs_to :team_stats1, class_name: "TeamStat", dependent: :destroy
  belongs_to :team_stats2, class_name: "TeamStat", dependent: :destroy
  accepts_nested_attributes_for :team_stats1
  accepts_nested_attributes_for :team_stats2

  validates_presence_of :datetime, :field, :league_id
  validate :team1_exists, :team2_exists, :teams_differ, :winners_losers, :same_league

  def self.default_scope
    order("datetime ASC")
  end

  def self.active
    joins(:team_stats1).where.not("team_stats.goals IS NULL AND league_id = ?", League.current.id)
  end

  def date
    datetime.strftime("%m/%d/%Y") if datetime
  end

  def time
    datetime.strftime("%I:%M %p") if datetime
  end

  def team1
    team_stats1.try(:team)
  end

  def team2
    team_stats2.try(:team)
  end

  def teams
    [team1, team2]
  end

  private
  def team1_exists
    unless team1
      errors.add(:team_stats1, "team must exist")
    end
  end

  def team2_exists
    unless team2
      errors.add(:team_stats2, "team must exist")
    end
  end

  def same_league
    if team1 && team2 && (team1.league != team2.league || team1.league != league)
      errors.add(:league, "must be the same")
    end
  end

  def teams_differ
    if team1 && team2 && team1 == team2
      errors.add(:teams, "must differ")
    end
  end

  def winners_losers
    if winner && loser && winner == loser
      errors.add(:winners, "must be different than losers")
    end
  end
end
