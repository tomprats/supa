class PlayerAwardsController < ApplicationController
  before_filter :check_admin_level

  def index
    @player_awards = PlayerAward.all
    @awards = {
      most_valuable: {},
      offensive: {},
      defensive: {},
      rookie: {},
      female: {},
      comeback: {},
      captain: {},
      spirit: {},
      iron_man: {},
      most_outspoken: {},
      most_improved: {},
      hustle: {},
      best_layouts: {},
      most_underrated: {},
      sportsmanship: {}
    }
    @player_awards.each do |award|
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

  private
  def check_admin_level
    if current_user.admin != "super"
      redirect_to profile_path, notice: "You are not authorized to be there!"
    end
  end
end
