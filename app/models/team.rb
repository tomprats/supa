class Team < ActiveRecord::Base
  belongs_to              :league
  has_and_belongs_to_many :players, class_name: 'User'
  belongs_to              :captain, class_name: 'User'
  has_many                :team_stats
  has_many                :drafted_players
  has_many                :wins,    class_name: 'Game', foreign_key: 'winner_id'
  has_many                :losses,  class_name: 'Game', foreign_key: 'loser_id'
  accepts_nested_attributes_for :players

  validates_presence_of :name, :captain_id, :league_id

  def games
    wins + losses
  end
end
