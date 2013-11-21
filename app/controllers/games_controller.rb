class GamesController < ApplicationController
  def create
    if params[:game][:winner_id] && params[:game][:loser_id]
      if params[:game][:winner_id] == params[:game][:loser_id]
        redirect_to :back, :alert => "A team cannot play itself!"
      else
        params[:game][:team_stats1_attributes][:team_id] = params[:game][:winner_id]
        params[:game][:team_stats2_attributes][:team_id] = params[:game][:loser_id]
        params[:game][:creator_id] = current_user.id
        Game.create(game_params)
        redirect_to :back, :notice => "Game was successfully saved!"
      end
    else
      redirect_to :back, :alert => "A game must have a winner and loser!"
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.update(game_params)
    redirect_to home_path, :notice => "Game successfully updated."
  end

  def destroy
    @game = Game.find(params[:id]).destroy
    redirect_to :back, :notice => "Game was successfully destroyed."
  end

  private
  def game_params
    params.require(:game).permit(:winner_id,
                                 :loser_id,
                                 :creator_id,
                                 :team_stats1_id,
                                 :team_stats2_id
                                )
  end
end
