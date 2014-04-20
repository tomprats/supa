class Payment < ActiveRecord::Base
  belongs_to :registration
  has_one :league, through: :registration

  delegate :price, to: :league

  def paid?
    paid
  end
end
