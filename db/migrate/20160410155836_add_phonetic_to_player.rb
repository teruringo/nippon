class AddPhoneticToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :phonetic, :string
  end
end
