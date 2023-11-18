class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :brand_name
      t.string :item_name
      t.string :image_url
      t.string :item_url
      t.string :price
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
