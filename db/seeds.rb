require "json"
require "open-uri"
require "faker"
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning database..."
Bookmark.destroy_all
List.destroy_all
Movie.destroy_all

url = "https://tmdb.lewagon.com/movie/top_rated"
response = URI.open(url).read
data = JSON.parse(response)

movies_data = data["results"].first(10)

movies = movies_data.map do |movie_data|
  Movie.find_or_create_by!(title: movie_data["title"]) do |m|
    m.overview = movie_data["overview"]
    m.poster_url = "https://image.tmdb.org/t/p/original#{movie_data["poster_path"]}"
    m.rating = movie_data["vote_average"]
  end
end

puts "Movies created"

# lists
drama = List.create!(name: "Drama")
classics = List.create!(name: "Classics")
watchlist = List.create!(name: "Watch list")

lists = [drama, classics, watchlist]

puts "Lists created"

10.times do
  movie = movies.sample
  list = lists.sample

  next if Bookmark.exists?(movie: movie, list: list)

  Bookmark.create!(
    movie: movie,
    list: list,
    comment: Faker::Movie.quote
  )
end

puts "bookmarks created"
