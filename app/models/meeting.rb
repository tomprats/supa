class Meeting < ActiveRecord::Base
  belongs_to :questionnaire

  validates_presence_of :datetime

  def date
    self.datetime.strftime("%m/%d/%Y") if datetime
  end

  def time
    self.datetime.strftime("%I:%M %p") if datetime
  end
end
