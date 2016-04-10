class ChangeColumnToPlayers < ActiveRecord::Migration
  def self.up
    rename_column :players, :birth, :birth_day
    rename_column :players, :birth_p, :birth_place
    rename_column :players, :back_no, :uniform_number
  end
  def self.down
    rename_column :players, :birth_day, :birth
    rename_column :players, :birth_place, :birth_p
    rename_column :players, :uniform_number, :back_no
  end
end
