class Game < ActiveRecord::Base
  default_scope -> {order(date: :desc)}
end
