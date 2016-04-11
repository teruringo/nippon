class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
  end
  
  # attr_accessor :game
  # def game_title
  #   @game.tournament + @game.date
  # end
end
