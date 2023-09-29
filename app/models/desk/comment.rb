class Desk::Comment < ApplicationRecord
  belongs_to :user
  belongs_to :desk_post, class_name: 'Desk::Post'

  validates_presence_of :content
end
