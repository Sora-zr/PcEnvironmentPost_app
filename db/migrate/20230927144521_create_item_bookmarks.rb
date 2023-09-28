class CreateItemBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :item_bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :item_post, null: false, foreign_key: true

      t.timestamps
    end
    add_index :item_bookmarks, [:user_id, :item_post_id], unique: :true
  end
end
