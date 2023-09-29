FactoryBot.define do
  factory :desk_bookmark, class: 'Desk::Bookmark' do
    user { nil }
    desk_post { nil }
  end
end
