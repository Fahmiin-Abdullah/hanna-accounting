module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # /accounts
    field :accounts, [Types::AccountType], null: false

    def accounts
      Account.includes(:credit_transactions, :debit_transactions).all
    end
  end
end
