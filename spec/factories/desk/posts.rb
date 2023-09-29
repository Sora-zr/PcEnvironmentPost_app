FactoryBot.define do
  factory :desk_post, class: 'Desk::Post' do
    title { "MyString" }
    description { "MyText" }
    image { "MyString" }
    user { nil }
  end
end
