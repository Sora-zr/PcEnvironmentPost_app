# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

20.times do |n|
  user = User.new(
    name: Faker::Name.unique.name,
    email: Faker::Internet.unique.email,
    password: 'password',
  )
  user.avatar.attach(io: File.open(Rails.root.join("app/assets/images/default_avatar.png")), filename: "default_avatar.png")
  user.save

  post = Post.new(
    user: user,
    description: "sample_description-#{n}"
  )
  3.times do |i|
    post.images.attach(io: File.open(Rails.root.join("app/assets/images/sample#{i + 1}.jpg")), filename: "sample#{i + 1}.jpg")
  end
  post.save

end