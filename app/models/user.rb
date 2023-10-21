class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :post, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_likes, through: :likes, source: :post

  validates_presence_of :user_name, :email

  def own?(object)
    id == object.user_id
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation = user.password
      user.user_name = 'ゲストユーザー'
    end
  end

  def like?(post)
    post_likes.include?(post)
  end

  def like(post)
    post_likes << post
  end

  def unlike(post)
    post_likes.destroy(post)
  end
end
