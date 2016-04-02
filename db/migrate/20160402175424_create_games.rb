class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.date :date
      t.text :home_team
      t.text :away_team
      t.integer :home_gf
      t.integer :away_gf
      t.text :venue
      t.text :tournament
      t.text :lineup
      t.text :scorer

      t.timestamps null: false
    end
  end
end
