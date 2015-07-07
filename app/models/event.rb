class Event < ActiveRecord::Base
  belongs_to :creator,  class_name: "User"
  belongs_to :league
  belongs_to :field
  has_one :game

  validates_presence_of :datetime

  def date
    self.datetime.strftime("%m/%d/%Y") if datetime
  end

  def time
    self.datetime.strftime("%l:%M %p") if datetime
  end
end
