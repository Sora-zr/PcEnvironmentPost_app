class Item::Comment < ApplicationRecord
  belongs_to :user
  belongs_to :item_post, class_name: 'Item::Post'
end
