# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

cash_acc = Account.create!(name: 'Cash')
bank_acc = Account.create!(name: 'Bank')
comp_acc = Account.create!(name: 'Company')

Transaction.create!(description: 'Deposit cash to bank', from_account_id: cash_acc.id, to_account_id: bank_acc.id, amount: 100)
Transaction.create!(description: 'Withdraw from bank', from_account_id: bank_acc.id, to_account_id: cash_acc.id, amount: 500)
Transaction.create!(description: 'Seed funding (bank transfer)', from_account_id: bank_acc.id, to_account_id: comp_acc.id, amount: 200)
Transaction.create!(description: 'Seed funding (cash)', from_account_id: cash_acc.id, to_account_id: comp_acc.id, amount: 400)