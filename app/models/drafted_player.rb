class DraftedPlayer < ActiveRecord::Base
  belongs_to :draft
  belongs_to :team
  belongs_to :player, class_name: "User"
end
