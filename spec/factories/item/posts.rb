FactoryBot.define do
  factory :item_post, class: 'Item::Post' do
    name { "MyString" }
    description { "MyText" }
    image { "MyString" }
    user { nil }
  end
end
