class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :desk_post, class_name: 'Desk::Post', dependent: :destroy
  has_many :desk_comments, class_name: 'Desk::Comment', dependent: :destroy
  has_many :item_posts, class_name: 'Item::Post', dependent: :destroy
  has_many :item_comments, class_name: 'Item::Comment', dependent: :destroy
  has_many :item_bookmarks, class_name: 'Item::Bookmark', dependent: :destroy
  has_many :item_post_bookmarks, through: :item_bookmarks, source: :item_post

  validates_presence_of :user_name, :email

  def own?(object)
    id == object.user_id
  end

  def bookmark?(post)
    item_post_bookmarks.include?(post)
  end

  def bookmark(post)
    item_post_bookmarks << post
  end

  def unbookmark(post)
    item_post_bookmarks.destroy(post)
  end
end
