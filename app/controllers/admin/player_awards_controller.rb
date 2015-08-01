module Admin
  class PlayerAwardsController < ApplicationController
    def index
      @awards = {
        most_valuable: {},
        defensive: {},
        rookie: {},
        female: {},
        captain: {},
        spirit: {}
      }
      League.current.player_awards.each do |award|
        @awards.each do |key, value|
          id = award.try(key)
          if @awards[key][id]
            @awards[key][id] += 1
          else
            @awards[key][id] = 1
          end
        end
      end
    end
  end
end
