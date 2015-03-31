class CreateHintsUsersTable < ActiveRecord::Migration
  def change
    create_table :hints_users, :id => false  do |t|
      t.integer :hint_id
      t.integer :user_id
    end
  end
end
