class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.text :desc
      t.string :logo_file_name
      t.integer :logo_file_size
      t.string :logo_content_type
      t.datetime :logo_updated_at

      t.timestamps null: false
    end
  end
end
