require "json"
require "open-uri"
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
url = "https://tmdb.lewagon.com/movie/top_rated"
response = URI.open(url).read
data = JSON.parse(response)

movies = data["results"]

movies.first(10).each do |movie|
  Movie.create!(
    title: movie["title"],
    overview: movie["overview"],
    poster_url: movie["https://image.tmdb.org/t/p/original#{movie["poster_path"]}"],
    rating: movie["vote_average"]
  )
end

puts "Movies created"
