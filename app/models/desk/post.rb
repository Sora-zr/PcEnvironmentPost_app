class Desk::Post < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :description
end
