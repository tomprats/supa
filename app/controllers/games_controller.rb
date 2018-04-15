class GamesController < ApplicationController
  skip_before_action :require_user!, :check_attr

  def show
    @game = Game.find(params[:id])
  end
end
