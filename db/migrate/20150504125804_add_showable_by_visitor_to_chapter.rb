class AddShowableByVisitorToChapter < ActiveRecord::Migration
  def change
    add_column :chapters, :showable_by_visitor, :boolean
  end
end
