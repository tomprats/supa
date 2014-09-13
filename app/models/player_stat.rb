class PlayerStat < ActiveRecord::Base
  belongs_to :player, class_name: "User"
  belongs_to :team_stats, class_name: "TeamStat"

  delegate :league, to: :team_stats, allow_nil: true

  validates_presence_of :player
  validates :player_id, uniqueness: { scope: :team_stats_id }

  around_save :update_points

  private
  def update_points
    assists_changed = self.assists_changed?
    goals_changed = self.goals_changed?

    yield

    if assists_changed || goals_changed
      update_column(:points, assists.to_i + goals.to_i)
      team_stats.update_goals if goals_changed
    end
  end
end
