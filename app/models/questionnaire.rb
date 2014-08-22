class Questionnaire < ActiveRecord::Base
  belongs_to :user
  belongs_to :league
  has_many :meetings, dependent: :destroy

  validates_presence_of :user, :league

  accepts_nested_attributes_for :meetings

  def availability
    meetings.count.zero? ? 0 : 100 * meetings.count(&:available) / meetings.count
  end
end
