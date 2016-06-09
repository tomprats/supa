require "prawn/table"

class ShirtSizesPdf < Prawn::Document
  def initialize(league)
    super()

    @league = league
    @teams = league.teams

    add_heading
    add_table
  end

  private
  def add_heading
    text @league.name
  end

  def add_table
    @data = []
    @data << ["Team", "Name", "Size"]

    @teams.each do |team|
      team.players.each do |player|
        @data << [team.name, player.name, player.shirt_size]
      end
    end

    table(@data)
  end
end
