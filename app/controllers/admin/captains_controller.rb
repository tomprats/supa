module Admin
  class CaptainsController < ApplicationController
    def index
      @teams = Team.all
      @current_teams = League.current.teams
      @past_teams = Team.where.not(id: @current_teams.collect(&:id))

      @captains = @teams.collect { |t| [t.captain, t.cocaptain] }.flatten.compact
      @current_captains = @current_teams.collect { |t| [t.captain, t.cocaptain] }.flatten.compact
      @past_captains = @past_teams.collect { |t| [t.captain, t.cocaptain] }.flatten.compact
    end
  end
end

