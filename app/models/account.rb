class Account < ApplicationRecord
  has_many :credit_transactions, class_name: 'Transaction', foreign_key: 'to_account_id'
  has_many :debit_transactions, class_name: 'Transaction', foreign_key: 'from_account_id'
end
