# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

10.times do |n|
  user = User.create!(
    user_name: Faker::Name.unique.name,
    email: Faker::Internet.unique.email,
    password: 'password',
  )

  Desk::Post.create!(
    user: user,
    title: "sample_title-#{n}",
    description: "sample_description-#{n}"
  )
end

30.times do |n|
  Item::Post.create!(
    user: User.offset(rand(User.count)).first,
    name: "sample_name-#{n}",
    description: "sample_description-#{n}"
  )
end