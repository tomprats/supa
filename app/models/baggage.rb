class Baggage < ActiveRecord::Base
  belongs_to :league
  belongs_to :approver, class_name: "User"
  belongs_to :partner1, class_name: "User"
  belongs_to :partner2, class_name: "User"

  validates_presence_of :league_id, :partner1_id, :partner2_id
  validate :partners_differ
  validate :registered

  def other_partner(user_id)
    user_id == partner1_id ? partner2 : partner1
  end

  def add_comment(user_id, comment)
    if user_id == partner1_id
      update(comment1: comment)
    else
      update(comment2: comment)
    end
  end

  def self.find_by_partners(id1, id2, league_id)
    Baggage.find_by("""
      (league_id = ?)
      AND ((partner1_id = ? AND partner2_id = ?)
      OR (partner1_id = ? AND partner2_id = ?))
    """, league_id, id1, id2, id2, id1)
  end

  private
  def partners_differ
    if partner1_id && partner2_id && partner1_id == partner2_id
      errors.add(:partners, "must differ")
    end
  end

  def registered
    if approved
      unless partner1.registered(league.id) && partner2.registered(league.id)
        errors.add(:partners, "must be registered")
      end
    end
  end
end
