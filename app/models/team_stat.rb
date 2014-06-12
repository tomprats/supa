class TeamStat < ActiveRecord::Base
  has_many   :player_stats, -> { joins(:player).includes(:player).order("users.last_name ASC") }, foreign_key: :team_stats_id, dependent: :destroy
  belongs_to :team

  accepts_nested_attributes_for :player_stats, allow_destroy: true

  def self.active
    where.not(goals: nil)
  end

  def update_goals
    update_attributes(goals: player_stats.reduce(0){|sum, ps| sum + ps.goals.to_i })
  end
end
