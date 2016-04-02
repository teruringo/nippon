class StaticPagesController < ApplicationController
  def home
    @games = Game.paginate(page: params[:page])
  end

  def help
  end

  def about
  end
end
