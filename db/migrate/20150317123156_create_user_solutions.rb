class CreateUserSolutions < ActiveRecord::Migration
  def change
    create_table :user_solutions do |t|
      t.text :code
      t.integer :points
      t.integer :challenge_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
