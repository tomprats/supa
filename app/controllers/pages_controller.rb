class PagesController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :check_attr

  def current
    @league = League.current
    render_league
  end

  def summer
    @league = League.summer
    render_league
  end

  def fall
    @league = League.fall
    render_league
  end

  def spring
    @league = League.spring
    render_league
  end

  private
  def render_league
    @teams = @league.teams
    @events = @league.events

    render :season
  end
end
