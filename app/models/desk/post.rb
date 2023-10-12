class Desk::Post < ApplicationRecord
  belongs_to :user
  has_many :desk_comments, class_name: 'Desk::Comment', foreign_key: 'desk_post_id', dependent: :destroy
  has_many :desk_likes, class_name: 'Desk::Like', foreign_key: 'desk_post_id', dependent: :destroy
  has_one_attached :image

  validates_presence_of :title, :description
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "有効なフォーマットではありません" },
            size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }
end
