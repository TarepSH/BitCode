class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :name
      t.string :picture_file_name
      t.integer :picture_file_size
      t.string :picture_content_type
      t.datetime :picture_updated_at
      t.integer :chapter_id

      t.timestamps null: false
    end
  end
end
