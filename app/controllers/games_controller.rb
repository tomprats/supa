class GamesController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :check_attr

  def show
    @game = Game.find(params[:id])
  end
end
