class AddIndexToGames < ActiveRecord::Migration
  def change
    add_index :games, :date, unique: true
  end
end
