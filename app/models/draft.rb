class Draft < ActiveRecord::Base
  has_many :draft_groups, :dependent => :destroy

  def groups(captain)
    draft_groups.where(:captain_id => captain)
  end

  def players(captain)
    groups(captain).collect(&:draft_players).flatten
  end
end
