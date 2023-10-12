class Item::Like < ApplicationRecord
  belongs_to :user
  belongs_to :item_post, class_name: 'Item::Post'

  validates_uniqueness_of :user_id, scope: 'item_post_id'
end
