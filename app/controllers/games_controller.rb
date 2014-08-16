class GamesController < ApplicationController
  before_filter :check_admin_level

  def show
    @game = Game.find(params[:id])
  end
end
