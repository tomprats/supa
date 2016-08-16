class Payment < ApplicationRecord
  belongs_to :registration
  has_one :league, through: :registration

  delegate :price, to: :league

  def paid?
    paid
  end

  def self.type_collection
    [
      ["Visa", :visa],
      ["MasterCard", :mastercard],
      ["Discover", :discover],
      ["AmericanExpress", :amex]
    ]
  end
end
