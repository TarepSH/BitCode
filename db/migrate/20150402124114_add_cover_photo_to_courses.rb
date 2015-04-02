class AddCoverPhotoToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :cover_file_name, :string
    add_column :courses, :cover_file_size, :integer
    add_column :courses, :cover_content_type, :string
    add_column :courses, :cover_updated_at, :datetime
  end
end
