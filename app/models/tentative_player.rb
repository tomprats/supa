class TentativePlayer < ActiveRecord::Base
  belongs_to :player, class_name: "User"
  belongs_to :team

  validates_presence_of :player_id

  accepts_nested_attributes_for :player

  default_scope { order(created_at: :desc) }

  def baggage_partner
    baggage = Baggage.find_by("""
      (league_id = :league_id)
      AND (approved = :approved)
      AND (partner1_id = :id OR partner2_id = :id)
    """, league_id: team.league_id, approved: true, id: player.id)

    baggage.other_partner(player.id) if baggage
  end
end
