class Team < ActiveRecord::Base
  has_and_belongs_to_many :players, :class_name => 'User'
  accepts_nested_attributes_for :players

  scope :active,   -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def captain_collection
    User.all
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
      now - 0 => now - 0,
      now - 1 => now - 1,
      now - 2 => now - 2,
      now - 3 => now - 3,
      now - 4 => now - 4,
      now - 5 => now - 5
    }
  end
end
