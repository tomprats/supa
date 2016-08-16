class Token < ApplicationRecord
  belongs_to :user

  # Hack to fetch uuid value
  after_create :reload, on: :create

  def to_param
    uuid
  end
end
