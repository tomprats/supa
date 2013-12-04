class DraftPlayer < ActiveRecord::Base
  belongs_to :draft_group
  belongs_to :player, class_name: "User"
end
