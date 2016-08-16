class Registration < ApplicationRecord
  belongs_to :league
  belongs_to :user
  has_one :payment, dependent: :destroy

  delegate :paid, :paid?, to: :payment
  delegate :price, to: :league

  validates_presence_of :league_id, :user_id

  def registered?
    registered
  end

  def not_registered?
    !registered
  end
end
