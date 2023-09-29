class Desk::Post < ApplicationRecord
  belongs_to :user
  has_many :desk_comments, class_name: 'Desk::Comment', foreign_key: 'desk_post_id', dependent: :destroy

  validates_presence_of :title, :description
end
