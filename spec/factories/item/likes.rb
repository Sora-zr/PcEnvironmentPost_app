FactoryBot.define do
  factory :item_like, class: 'Item::Like' do
    user { nil }
    item_post { nil }
  end
end
