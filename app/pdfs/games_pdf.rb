require "prawn/table"

class GamesPdf < Prawn::Document
  def initialize(games)
    super()

    games = [games] unless games.try(:to_a).kind_of? Array
    games.each_with_index do |game, index|
      start_new_page unless index.zero?
      heading(game)
      team(game.team1)
      move_down 20
      team(game.team2)
    end
  end

  private
  def heading(game)
    x = cursor
    text_box game.name, align: :left, at: [0, x]
    text_box "#{game.date} #{game.time}", align: :right, at: [0, x]
  end

  def team(team)
    header = ["Player Name", "Assists", "Goals"]
    extra = 19 - team.players.count

    text_box team.name,
      size: 20,
      align: :center,
      at: [0, cursor]
    move_down 20

    data = [header]
    team.players.each do |player|
      data << [player.name, "", ""]
    end

    extra.times do
      data << ["", "", ""]
    end

    table(data,
      header: true,
      column_widths: [180, 180, 180],
      cell_style: { size: 10, height: 16, padding: 2 }
    ) do |table|
      table.row(0).font_style = :bold
      table.row(0).border_bottom_width = 3
      table.row(0).padding_bottom = 4
      table.row(0).height = 18
      table.row(0).size = 12
      table.row(0).position = :center
    end
  end
end
