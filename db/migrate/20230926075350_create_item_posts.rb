class CreateItemPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :item_posts do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :image
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
