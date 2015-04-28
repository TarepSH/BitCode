class AddYoutubeUrlToChapter < ActiveRecord::Migration
  def change
    add_column :chapters, :youtube_url, :string
  end
end
