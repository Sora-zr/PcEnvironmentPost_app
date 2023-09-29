FactoryBot.define do
  factory :desk_comment, class: 'Desk::Comment' do
    content { "MyText" }
    user { nil }
    desk_post { nil }
  end
end
