class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :item_posts, class_name: 'Item::Post', foreign_key: 'user_id', dependent: :destroy

  validates_presence_of :user_name, :email

  def own?(object)
    id == object.user_id
  end
end
