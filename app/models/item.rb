class Item < ApplicationRecord
  belongs_to :post

  def self.ransackable_attributes(auth_object = nil)
    %w[genre_name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[post]
  end
end
