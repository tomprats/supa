class Announcement < ActiveRecord::Base
  belongs_to :creator,  class_name: "User"

  validates_presence_of :heading, :text, :importance

  def self.default_scope
    order("importance DESC, created_at DESC")
  end
end
