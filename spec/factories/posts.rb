FactoryBot.define do
  factory :post do
    description { 'test_description' }

    association :user
    after(:build) do |post|
      3.times do |i|
        post.images.attach(io: File.open(Rails.root.join("app/assets/images/sample#{i + 1}.jpg")), filename: "sample#{i + 1}.jpg")
      end
    end
  end
end
