module Mutations
  class DeleteTransaction < Mutations::BaseMutation
    argument :id, ID, required: true

    field :transaction, Types::TransactionType, null: false
    field :errors, [String], null: false

    def resolve(id:)
      transaction = Transaction.find(id)

      if transaction.destroy
        {
          transaction: transaction,
          errors: []
        }
      else
        {
          transaction: nil,
          errors: transaction.errors.message
        }
      end
    end
  end
end
