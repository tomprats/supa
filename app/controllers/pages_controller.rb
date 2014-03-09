class PagesController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :check_attr

  def home
  end

  def spring2014
    @teams = Draft.where(year: 2014, season: "Spring").first.teams
  end
end
