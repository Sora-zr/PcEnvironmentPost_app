FactoryBot.define do
  factory :item_comment, class: 'Item::Comment' do
    user { nil }
    item_post { nil }
  end
end
