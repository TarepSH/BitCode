class CreateChallengeSteps < ActiveRecord::Migration
  def change
    create_table :challenge_steps do |t|
      t.string :step_text
      t.integer :challenge_id

      t.timestamps null: false
    end
  end
end
