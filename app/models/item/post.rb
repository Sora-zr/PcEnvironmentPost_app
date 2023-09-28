class Item::Post < ApplicationRecord
  belongs_to :user
  has_many :item_comments, class_name: 'Item::Comment', foreign_key:  'item_post_id', dependent: :destroy
  has_many :item_bookmarks, class_name: 'Item::Bookmark', foreign_key: 'item_post_id', dependent: :destroy

  acts_as_taggable_on :tags

  validates_presence_of :name, :description
end
