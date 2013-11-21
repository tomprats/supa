class Game < ActiveRecord::Base
  belongs_to :winner,   class_name: "Team"
  belongs_to :loser,    class_name: "Team"
  belongs_to :creator,  class_name: "User"
  belongs_to :team_stats1, class_name: "TeamStat"
  belongs_to :team_stats2, class_name: "TeamStat"
  accepts_nested_attributes_for :team_stats1
  accepts_nested_attributes_for :team_stats2

  validates_presence_of :winner_id, :loser_id

  scope :active,   -> { includes(:winner).where(:teams => { :active => true }) }
  scope :inactive, -> { includes(:winner).where(:teams => { :active => false }) }
end
