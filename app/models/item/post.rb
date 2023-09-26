class Item::Post < ApplicationRecord
  belongs_to :user

  validates_presence_of :name, :description
end
