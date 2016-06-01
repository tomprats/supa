require "prawn/table"

class UsersPdf < Prawn::Document
  def initialize(league)
    super()

    @league = league
    @users = User.registered(league.id).with_questionnaires(league.id)

    add_heading
    add_table
  end

  private
  def add_heading
    text @league.name
  end

  def add_table
    @data = []
    @data << ["Name", "Height", "Handling", "Defense", "Injuries", "Cocaptain"]
    @data << [nil, "Availability", "Cutting", "Fitness", "Teams", "Roles"]
    table(@data)
    move_down 20

    @data = []
    @users.each { |user| row(user) }

    options = { column_widths: [100, 40, 100, 100, 140, 60] }
    table(@data, options)
  end

  def row(user)
    q = user.questionnaires.first
    cocaptain = q.cocaptain ? "Cocaptain" : ""
    roles = q.handler ? "Handler" : ""
    roles += " / " if q.handler && q.cutter
    roles += q.cutter ? "Cutter" : ""
    roles = "None" unless q.handler || q.cutter
    @data << [user.name, q.height,             q.handling, q.defense, q.injuries, cocaptain]
    @data << [nil,       "#{q.availability}%", q.cutting,  q.fitness, q.teams,    roles]
  end
end
