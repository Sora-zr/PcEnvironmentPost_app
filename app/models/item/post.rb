class Item::Post < ApplicationRecord
  belongs_to :user
  has_many :item_comments, class_name: 'Item::Comment', foreign_key: 'item_post_id', dependent: :destroy
  has_many :item_bookmarks, class_name: 'Item::Bookmark', foreign_key: 'item_post_id', dependent: :destroy
  has_one_attached :image

  acts_as_taggable_on :tags

  validates_presence_of :name, :description
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                     message: "有効なフォーマットではありません" },
            size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }
end
