class CreateBadgesUsersTable < ActiveRecord::Migration
  def change
    create_table :badges_users, :id => false do |t|
      t.integer :badge_id
      t.integer :user_id

      t.timestamps
    end
  end
end
