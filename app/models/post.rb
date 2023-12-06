class Post < ApplicationRecord
  acts_as_taggable

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many_attached :images

  validates_presence_of :images
  validates :images, content_type: { in: %w[image/jpg image/jpeg image/png], message: "有効なフォーマットではありません。" },
            size: { less_than: 5.megabytes, message: "5MBを超える画像はアップロードできません" }
  validate :validate_image_count

  scope :visible, -> { joins(:user).merge(User.active) }
  scope :likes_sort, -> { left_joins(:likes).group('posts.id').order('count(likes.id) desc') }
  scope :random_sort, -> {
    random_order_function = ActiveRecord::Base.connection.adapter_name.downcase == 'postgresql' ? 'RANDOM()' : 'RAND()'
    order(Arel.sql(random_order_function))
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[genre_name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[items]
  end

  # 並べ替え用のメソッド
  def self.sort_posts(sort_option, page)
    posts = includes(:user)
    case sort_option
    when 'old'
      posts.order(created_at: :asc).page(page)
    when 'like'
      posts.likes_sort.page(page)
    when 'random'
      posts.random_sort.page(page)
    else
      posts.order(created_at: :desc).page(page)
    end
  end

  # ユーザーがいいねしていない投稿をランダムで2件取得
  def self.recommended_for_user(user)
    random_order_function = ActiveRecord::Base.connection.adapter_name.downcase == 'postgresql' ? 'RANDOM()' : 'RAND()'
    where.not(id: user.likes.pluck(:post_id)).order(Arel.sql(random_order_function)).limit(2)
  end

  private

  # 画像枚数制限のためのバリデーション
  def validate_image_count
    if images.attached? && images.count > 8
      errors.add(:images, "は最大8枚までです。")
      images.purge
    end
  end
end
