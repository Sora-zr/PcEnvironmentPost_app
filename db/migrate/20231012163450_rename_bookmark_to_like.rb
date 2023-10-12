class RenameBookmarkToLike < ActiveRecord::Migration[7.0]
  def change
    rename_table :desk_bookmarks, :desk_likes
    rename_table :item_bookmarks, :item_likes
  end
end
