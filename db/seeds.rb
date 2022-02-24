# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Plan.create(name: 'Bronze Box', price_in_cents: 1999)
Plan.create(name: 'Silver Box', price_in_cents: 4900)
Plan.create(name: 'Gold Box', price_in_cents: 9900)
