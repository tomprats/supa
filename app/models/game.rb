class Game < ActiveRecord::Base
  belongs_to :event, dependent: :destroy
  belongs_to :team_stats1, class_name: "TeamStat", dependent: :destroy
  belongs_to :team_stats2, class_name: "TeamStat", dependent: :destroy
  accepts_nested_attributes_for :event
  accepts_nested_attributes_for :team_stats1
  accepts_nested_attributes_for :team_stats2

  delegate :league, :datetime, :date, :time, :field, to: :event, allow_nil: true

  validate :team1_exists, :team2_exists, :teams_differ, :same_league

  def self.default_scope
    joins(:event).order("events.datetime ASC")
  end

  def name
    teams.collect(&:name).join(" vs ")
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

  def winner
    diff = team_stats1.goals.to_i - team_stats2.goals.to_i
    if diff > 0
      team_stats1.team
    elsif diff < 0
      team_stats2.team
    else
      nil
    end
  end

  def winner_id
    diff = team_stats1.goals.to_i - team_stats2.goals.to_i
    if diff > 0
      team_stats1.team_id
    elsif diff < 0
      team_stats2.team_id
    else
      0
    end
  end

  def loser
    diff = team_stats1.goals.to_i - team_stats2.goals.to_i
    if diff > 0
      team_stats2.team
    elsif diff < 0
      team_stats1.team
    else
      nil
    end
  end

  def loser_id
    diff = team_stats1.goals.to_i - team_stats2.goals.to_i
    if diff > 0
      team_stats2.team_id
    elsif diff < 0
      team_stats1.team_id
    else
      0
    end
  end

  def tie?
    diff = team_stats1.goals.to_i - team_stats2.goals.to_i
    diff == 0 && team_stats1.goals
  end

  def score
    if team_stats1.goals && team_stats2.goals
      "#{team_stats1.goals} to #{team_stats2.goals}"
    else
      "Not Yet Played"
    end
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
end
