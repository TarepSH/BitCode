class ExtendsFiledsOfCourses < ActiveRecord::Migration
  def change
    add_column :courses, :published, :boolean, :default => false
    add_column :courses, :coming_soon, :boolean, :default => true
  end
end
