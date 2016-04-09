class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.date :birth
      t.integer :height
      t.integer :weight
      t.string :birth_p
      t.string :web_site
      t.string :twitter
      t.string :facebook
      t.string :belongs
      t.integer :back_no

      t.timestamps null: false
    end
  end
end
