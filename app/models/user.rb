class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :desk_post, class_name: 'Desk::Post', dependent: :destroy
  has_many :desk_comments, class_name: 'Desk::Comment', dependent: :destroy
  has_many :desk_likes, class_name: 'Desk::Like', dependent: :destroy
  has_many :desk_post_likes, through: :desk_likes, source: :desk_post
  has_many :item_posts, class_name: 'Item::Post', dependent: :destroy
  has_many :item_comments, class_name: 'Item::Comment', dependent: :destroy
  has_many :item_likes, class_name: 'Item::Like', dependent: :destroy
  has_many :item_post_likes, through: :item_likes, source: :item_post

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
    if post.class == Desk::Post
      desk_post_likes.include?(post)
    elsif post.class == Item::Post
      item_post_likes.include?(post)
    end
  end

  def like(post)
    if post.class == Desk::Post
      desk_post_likes << post
    elsif post.class == Item::Post
      item_post_likes << post
    end
  end

  def unlike(post)
    if post.class == Desk::Post
      desk_post_likes.destroy(post)
    elsif post.class == Item::Post
      item_post_likes.destroy(post)
    end
  end
end
