class DraftGroup < ActiveRecord::Base
  has_many :draft_players, :dependent => :destroy
  belongs_to :captain, :class_name => "User"
end
