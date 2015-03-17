class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :name
      t.text :desc
      t.integer :chapter_id

      t.timestamps null: false
    end
  end
end
