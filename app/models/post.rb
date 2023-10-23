class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many_attached :images

  validates_presence_of :description
  validates :images, content_type: { in: %w[image/jpeg image/gif image/png image/jpg], message: "有効なフォーマットではありません。" },
            size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

  validates_presence_of :images
end
