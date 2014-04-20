class League < ActiveRecord::Base
  has_one :draft, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :games, dependent: :destroy

  validates_presence_of :season, :year

  def self.default_scope
    order(year: :desc, season: :desc)
  end

  def self.active
    where(active: true)
  end

  def self.next
    first
  end

  def self.most_recent
    active.first
  end

  def self.summer
    where(season: "Summer", year: 2014).first
  end

  def self.spring
    where(season: "Spring", year: 2014).first
  end

  def name
    "#{season} League #{year}"
  end

  def self.season_collection
    {
      "Summer" => "Summer",
      "Spring" => "Spring"
    }
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
