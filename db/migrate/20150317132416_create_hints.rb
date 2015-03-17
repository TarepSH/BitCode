class CreateHints < ActiveRecord::Migration
  def change
    create_table :hints do |t|
      t.string :title
      t.text :desc
      t.integer :points
      t.integer :challenge_id

      t.timestamps null: false
    end
  end
end
