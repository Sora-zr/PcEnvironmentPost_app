class CreateDeskBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :desk_bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :desk_post, null: false, foreign_key: true

      t.timestamps
    end
    add_index :desk_bookmarks, [:user_id, :desk_post_id], unique: :true
  end
end
