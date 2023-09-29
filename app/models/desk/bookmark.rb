class Desk::Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :desk_post, class_name: 'Desk::Post'

  validates_uniqueness_of :user_id, scope: 'desk_post_id'
end
