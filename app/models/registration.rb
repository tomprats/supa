class Registration < ApplicationRecord
  belongs_to :league
  belongs_to :user
  has_one :payment, dependent: :destroy

  validates_presence_of :league_id, :user_id

  def registered?
    registered
  end

  def not_registered?
    !registered
  end

  def paid?
    (payment || build_payment).paid? || league.current_price.zero?
  end
end
