class Event < ActiveRecord::Base
  belongs_to :creator,  class_name: "User"
  belongs_to :league
  belongs_to :field
  has_one :game

  def date
    self.datetime.strftime("%m/%d/%Y") if datetime
  end

  def time
    self.datetime.strftime("%I:%M %p") if datetime
  end
end
