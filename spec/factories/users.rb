FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }

    after(:build) do |user|
      user.avatar.attach(io: File.open(Rails.root.join("spec/fixtures/test_avatar.png")), filename: "test_avatar.png")
    end
  end
end
