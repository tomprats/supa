class Team < ActiveRecord::Base
  has_and_belongs_to_many :players, :class_name => 'User'
  belongs_to              :captain, :class_name => 'User'
  has_many                :team_stats
  has_many                :drafted_players
  has_many                :wins,    :class_name => 'Game', :foreign_key => 'winner_id'
  has_many                :losses,  :class_name => 'Game', :foreign_key => 'loser_id'
  accepts_nested_attributes_for :players

  validates_presence_of :name, :captain_id, :season, :year, :active

  scope :active,   -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def games
    # Should be ordered
    wins + losses
  end

  def captain_collection
    User.all
  end

  def paid?
    users.all?(&:paid?)
  end

  def season_collection
    {
      "Summer" => "Summer",
      "Fall" => "Fall",
      "Spring" => "Spring"
    }
  end

  def year_collection
    now = Date.today.year
    {
      now + 1 => now + 1,
      now - 0 => now - 0,
      now - 1 => now - 1,
      now - 2 => now - 2,
      now - 3 => now - 3,
      now - 4 => now - 4,
      now - 5 => now - 5
    }
  end
end
