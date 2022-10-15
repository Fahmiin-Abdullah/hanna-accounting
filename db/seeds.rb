# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

['Debit', 'Credit'].each do |ac|
  account = Account.create!(name: ac)

  5.times do |index|
    account.transactions.create!(description: "Test description #{index + 1}", amount: (index + 1) * 100)
  end
end