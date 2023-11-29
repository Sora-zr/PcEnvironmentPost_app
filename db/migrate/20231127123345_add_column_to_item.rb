class AddColumnToItem < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :genre_name, :string
  end
end
