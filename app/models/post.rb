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
    else
      posts.order(created_at: :desc).page(page)
    end
  end

  # ユーザーがいいねしていない投稿をランダムで2件取得
  def self.recommended_for_user(user)
    random_order_function = ActiveRecord::Base.connection.adapter_name.downcase == 'postgresql' ? 'RANDOM()' : 'RAND()'
    where.not(id: user.likes.pluck(:post_id)).where.not(user_id: user.id).order(Arel.sql(random_order_function)).limit(2)
  end

  # 診断用のアルゴリズム
  def self.diagnose(params)
    selected_posts = []
    item_conditions = []

    item_conditions << { column: 'items.genre_name', value: '%マウス%' } if params[:selected_1] == 'Yes'
    item_conditions << { column: 'items.genre_name', value: '%キーボード%' } if params[:selected_1] == 'Yes'
    item_conditions << { column: 'items.genre_name', value: '%パソコンデスク%' } if params[:selected_3] == 'Yes'
    item_conditions << { column: 'items.genre_name', value: '%チェア%' } if params[:selected_4] == 'Yes'
    item_conditions << { column: 'items.genre_name', value: '%ノートPC%' } if params[:selected_5] == 'Yes'
    item_conditions << { column: 'items.genre_name', value: '%ヘッドホン%' } if params[:selected_6] == 'Yes'
    item_conditions << { column: 'items.genre_name', value: '%スピーカー%' } if params[:selected_6] == 'Yes'
    item_conditions << { column: 'items.genre_name', value: '%ゲーミング%' } if params[:selected_7] == 'Yes'
    item_conditions << { column: 'items.genre_name', value: '%観葉植物%' } if params[:selected_8] == 'Yes'

    if params[:selected_2] == '1台'
      selected_posts.concat(Post.joins(:items).where(items: { genre_name: 'ディスプレイ' }).group(:id).having('COUNT(items.id) = 1'))
    elsif params[:selected_2] == '2台以上'
      selected_posts.concat(Post.joins(:items).where(items: { genre_name: 'ディスプレイ' }).group(:id).having('COUNT(items.id) >= 2'))
    end

    item_conditions.each do |condition|
      selected_posts.concat(Post.joins(:items).where("#{condition[:column]} LIKE ?", condition[:value]))
    end

    return selected_posts.uniq
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
