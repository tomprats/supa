class Questionnaire < ApplicationRecord
  belongs_to :user
  belongs_to :league
  has_many :meetings, -> { order(:datetime) }, dependent: :destroy

  validates_presence_of :user, :league

  accepts_nested_attributes_for :meetings

  def availability
    meetings.count.zero? ? 0 : 100 * meetings.where(available: true).count / meetings.count
  end
end
