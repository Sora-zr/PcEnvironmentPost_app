# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

50.times do |n|
  user = User.create!(
    user_name: Faker::Name.unique.name,
    email: Faker::Internet.unique.email,
    password: 'password',
  )

  post = Post.create!(
    user: user,
    description: "sample_description-#{n}"
  )

  3.times do |i|
    post.images.attach(io: File.open(Rails.root.join("app/assets/images/sample#{i + 1}.jpg")), filename: "sample#{i + 1}.jpg")
  end
end