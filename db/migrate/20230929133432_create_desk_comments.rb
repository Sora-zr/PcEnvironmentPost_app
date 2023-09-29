class CreateDeskComments < ActiveRecord::Migration[7.0]
  def change
    create_table :desk_comments do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true
      t.references :desk_post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
