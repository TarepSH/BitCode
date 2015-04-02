class AddIsFreeToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :is_free, :boolean, default: true
  end
end
