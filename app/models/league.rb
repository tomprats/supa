class League < ActiveRecord::Base
  has_one :draft, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :games, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :games, through: :events

  validates_presence_of :season, :year

  after_save if: :current_changed? do |league|
    if league.current
      League.update_all(current: false)
      league.update_column(:current, true)
    else
      league.update_column(:current, false)
    end
  end

  def self.default_scope
    order(year: :desc, season: :desc)
  end

  def self.current
    find_by(current: true)
  end

  def self.summer
    find_by(season: "Summer")
  end

  def self.fall
    find_by(season: "Fall")
  end

  def self.spring
    find_by(season: "Spring")
  end

  def name
    "#{season} League #{year}"
  end

  def current_price
    registration? ? price : late_price
  end

  def self.season_collection
    {
      "Summer" => "Summer",
      "Fall" => "Fall",
      "Spring" => "Spring"
    }
  end

  def self.state_collection
    {
      "None" => "None",
      "Registration" => "Registration",
      "Pre Draft" => "Pre Draft",
      "Draft" => "Draft",
      "Late Registration" => "Late Registration",
      "In Progress" => "In Progress",
      "Over" => "Over"
    }
  end

  def registration?
    state == "Registration"
  end

  def late_registration?
    state == "Late Registration"
  end

  def in_progress?
    state == "In Progress"
  end

  def over?
    state == "Over"
  end

  def self.year_collection
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
