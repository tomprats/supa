class TentativePlayer < ActiveRecord::Base
  belongs_to :player, class_name: "User"

  validates_presence_of :player_id

  accepts_nested_attributes_for :player

  default_scope order(created_at: :desc)
end
