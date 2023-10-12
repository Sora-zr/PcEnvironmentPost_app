FactoryBot.define do
  factory :desk_like, class: 'Desk::Like' do
    user { nil }
    desk_post { nil }
  end
end
