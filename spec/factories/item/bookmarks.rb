FactoryBot.define do
  factory :item_bookmark, class: 'Item::Bookmark' do
    user { nil }
    item_post { nil }
  end
end
