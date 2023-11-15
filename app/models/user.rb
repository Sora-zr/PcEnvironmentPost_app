class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  has_one :post, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_likes, through: :likes, source: :post
  has_many :bookmarks, dependent: :destroy
  has_many :post_bookmarks, through: :bookmarks, source: :post
  has_one_attached :avatar

  validates :name, presence: true,  length: { maximum: 20, minimum: 1 }
  validates :email, presence: true, uniqueness: true
  validates :avatar, content_type: { in: %w[image/jpg image/jpeg image/png], message: "有効なフォーマットではありません。" },
            size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

  scope :active, -> { where(is_deleted: false) }
  scope :deleted_user, -> { where(is_deleted: 1).where('deleted_at < ?', 10.days.ago) }

  # Googleログイン用メソッド
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.png')),
                         filename: 'default_avatar.png',
                         content_type: 'image/png')
    end
  end

  # ゲストユーザー作成用メソッド
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation = user.password
      user.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'guest_avatar.png')),
                         filename: 'guest_avatar.png',
                         content_type: 'image/png')
      user.name = 'ゲストユーザー'
    end
  end

  def active_for_authentication?
    super && (self.is_deleted == false)
  end

  # オブジェクトが自身のものか確認
  def own?(object)
    id == object.user_id
  end

  # いいね機能
  def like?(post)
    post_likes.include?(post)
  end

  def like(post)
    post_likes << post
  end

  def unlike(post)
    post_likes.destroy(post)
  end

  # ブックマーク機能
  def bookmark?(post)
    post_bookmarks.include?(post)
  end

  def bookmark(post)
    post_bookmarks << post
  end

  def unbookmark(post)
    post_bookmarks.destroy(post)
  end
end
