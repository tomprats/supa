class PagesController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :check_attr

  def home
  end

  def spring2014
    @announcements = Announcement.all
    @teams = Draft.where(year: 2014, season: "Spring").first.teams
    @games = Game.all.group_by { |game| game.date }
    @games.keys.each do |date|
      name = @games[date].collect { |g| g.name }.reject { |g| g.blank? }.first
      fields = @games[date].collect { |g| g.field }.uniq
      times = @games[date].collect { |g| g.time }.uniq
      @games[date] = {
        games: @games[date],
        name: name,
        fields: fields,
        times: times
      }
    end
  end
end
