class RemoveCodeFromUserSolutions < ActiveRecord::Migration
  def up
    remove_column :user_solutions, :code
  end

  def down
    add_column :user_solutions, :code, :text
  end
end
