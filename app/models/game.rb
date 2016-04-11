class Game < ActiveRecord::Base
  default_scope -> {order(date: :desc)}
  
  # attr_accessor :game
  
  def game_title
    "#{tournament}（#{date}）#{home_team} #{home_gf} - #{away_gf} #{away_team}"
  end

end
