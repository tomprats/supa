class Page < ActiveRecord::Base
  belongs_to :creator,  class_name: "User"

  validates_format_of :path, with: /\A[a-z][a-z0-9_-]+\Z/
  validates_uniqueness_of :path
  validate :path_is_not_taken
  validates_presence_of :name, :path, :text, :importance

  def self.default_scope
    order(importance: :desc, created_at: :desc)
  end

  private
  def path_is_not_taken
    exists = Rails.application.routes.recognize_path("/#{path}", method: :get) rescue nil
    errors.add(:path, "conflicts with existing path (/#{path})") if exists && exists[:path] != path
  end
end
