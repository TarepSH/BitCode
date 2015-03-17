class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :title
      t.text :desc
      t.string :video_file_name
      t.integer :video_file_size
      t.string :video_content_type
      t.datetime :video_updated_at
      t.integer :course_id

      t.timestamps null: false
    end
  end
end
