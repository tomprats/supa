class PagesController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :check_attr

  def letsencrypt
    render text: "sXN0ObcfmrczOMUD4vAlPt_LSNAZwXK2HvN0XXhnQkw.Ys6D-B9BwVDfTv7J6Nt4cn_qX8RwGkG72j8JrNwzjlU"
  end

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

  def page
    @page = Page.find_by(path: params[:path]) || not_found
    @html = Rails.cache.fetch(@page) do
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
      markdown.render(@page.text).html_safe
    end
  end

  private
  def render_league
    @teams = @league.teams
    @events = @league.events
    @birthdays = User.where("""
      extract(month from birthday) = ?
      AND extract(day from birthday) = ?
    """, Time.zone.today.month, Time.zone.today.day)

    render :season
  end
end
