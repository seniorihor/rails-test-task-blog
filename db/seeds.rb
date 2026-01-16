# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create default user accounts

john = User.create!(
  username: "johndoe",
  first_name: "John",
  last_name: "Doe",
  email: "john.doe@gmail.com"
)

jan = User.create!(
  username: "Kowalski",
  first_name: "Jan",
  last_name: "Kowalski",
  email: "jan@kowalski.com"
)

post = Post.create!(
  title: "My first post",
  content: "This is the content of my first post.",
  created_by: jan
)
