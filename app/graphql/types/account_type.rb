# frozen_string_literal: true

module Types
  class AccountType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :balance, Float
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :credit_transactions, [Types::TransactionType], null: true
    field :debit_transactions, [Types::TransactionType], null: true
  end
end
