class GamesController < ApplicationController
  skip_before_filter :require_user!, :check_attr

  def show
    @game = Game.find(params[:id])
  end
end
