module Types
  class MutationType < Types::BaseObject
    field :create_transaction, mutation: Mutations::CreateTransaction
    field :update_transaction, mutation: Mutations::UpdateTransaction
    field :delete_transaction, mutation: Mutations::DeleteTransaction
  end
end
