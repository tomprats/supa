class Meeting < ApplicationRecord
  belongs_to :event
  belongs_to :questionnaire

  delegate :date, :time, to: :event
end
