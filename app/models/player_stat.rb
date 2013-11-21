class PlayerStat < ActiveRecord::Base
  has_one :player, class_name: "User"
end
