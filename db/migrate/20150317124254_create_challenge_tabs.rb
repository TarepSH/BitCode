class CreateChallengeTabs < ActiveRecord::Migration
  def change
    create_table :challenge_tabs do |t|
      t.string :name
      t.string :language_name
      t.text :starter_code
      t.integer :challenge_id

      t.timestamps null: false
    end
  end
end
