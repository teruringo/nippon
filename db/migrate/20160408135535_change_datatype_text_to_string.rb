class ChangeDatatypeTextToString < ActiveRecord::Migration
  def change
    change_column :games, :home_team, :string
    change_column :games, :away_team, :string
    change_column :games, :venue, :string
    change_column :games, :tournament, :string
    change_column :games, :lineup, :string
    change_column :games, :scorer, :string
    change_column :players, :name, :string
    change_column :players, :birth_p, :string
    change_column :players, :web_site, :string
    change_column :players, :twitter, :string
    change_column :players, :facebook, :string
    change_column :players, :belongs, :string
  end
end
