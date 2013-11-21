class TeamStat < ActiveRecord::Base
  has_many   :player_stats
  belongs_to :team
  accepts_nested_attributes_for :player_stats
end
