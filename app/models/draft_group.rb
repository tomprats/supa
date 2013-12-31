class DraftGroup < ActiveRecord::Base
  has_many :draft_players, :dependent => :destroy
  belongs_to :captain, :class_name => "User"
  belongs_to :draft

  accepts_nested_attributes_for :draft_players
end
