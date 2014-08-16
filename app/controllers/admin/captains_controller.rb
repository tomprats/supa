module Admin
  class CaptainsController < ApplicationController
    def index
      @teams = Team.all
      @current_teams = League.summer.teams
      @past_teams = Team.where.not(id: @current_teams.collect(&:id))

      @captains = @teams.collect { |t| t.captain }
      @current_captains = @current_teams.collect { |t| t.captain }
      @past_captains = @past_teams.collect { |t| t.captain }
    end
  end
end

