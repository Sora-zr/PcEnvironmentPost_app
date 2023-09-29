class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :desk_post, class_name: 'Desk::Post', dependent: :destroy
  has_many :desk_comments, class_name: 'Desk::Comment', dependent: :destroy
  has_many :desk_bookmarks, class_name: 'Desk::Bookmark', dependent: :destroy
  has_many :desk_post_bookmarks, through: :desk_bookmarks, source: :desk_post
  has_many :item_posts, class_name: 'Item::Post', dependent: :destroy
  has_many :item_comments, class_name: 'Item::Comment', dependent: :destroy
  has_many :item_bookmarks, class_name: 'Item::Bookmark', dependent: :destroy
  has_many :item_post_bookmarks, through: :item_bookmarks, source: :item_post

  validates_presence_of :user_name, :email

  def own?(object)
    id == object.user_id
  end

  def bookmark?(post)
    if post.class == Desk::Post
      desk_post_bookmarks.include?(post)
    elsif post.class == Item::Post
      item_post_bookmarks.include?(post)
    end
  end

  def bookmark(post)
    if post.class == Desk::Post
      desk_post_bookmarks << post
    elsif post.class == Item::Post
      item_post_bookmarks << post
    end
  end

  def unbookmark(post)
    if post.class == Desk::Post
      desk_post_bookmarks.destroy(post)
    elsif post.class == Item::Post
      item_post_bookmarks.destroy(post)
    end
  end
end
