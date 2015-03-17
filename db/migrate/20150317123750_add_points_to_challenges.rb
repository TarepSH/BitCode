class AddPointsToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :points, :integer
  end
end
