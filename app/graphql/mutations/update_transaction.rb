module Mutations
  class UpdateTransaction < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :description, String, required: true
    argument :account_id, ID, required: true
    argument :amount, String, required: true

    field :transaction, Types::TransactionType, null: false
    field :errors, [String], null: false

    def resolve(id:, description:, account_id:, amount:)
      transaction = Transaction.find(id)

      if transaction.update(description: description, account_id: account_id, amount: amount)
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
