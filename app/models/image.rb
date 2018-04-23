class Image < ApplicationRecord
  belongs_to :creator,  class_name: "User"

  validates_presence_of :link, :src
  validates_format_of :link, :src, with: /\Ahttps?:\/\//, allow_nil: true, message: "should contain http(s)"

  def self.default_scope
    order(importance: :desc, created_at: :desc)
  end
end
