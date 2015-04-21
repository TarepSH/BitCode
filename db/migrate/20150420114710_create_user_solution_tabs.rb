class CreateUserSolutionTabs < ActiveRecord::Migration
  def change
    create_table :user_solution_tabs do |t|
      t.integer :user_solution_id
      t.text :code
      t.string :name
      t.string :language_name

      t.timestamps null: false
    end
  end
end
