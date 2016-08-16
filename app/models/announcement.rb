class Announcement < ApplicationRecord
  belongs_to :creator,  class_name: "User"

  validates_presence_of :heading, :text, :importance

  def self.default_scope
    order(importance: :desc, created_at: :desc)
  end
end
