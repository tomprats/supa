class Field < ActiveRecord::Base
  has_many :games

  validates_presence_of :name
end
