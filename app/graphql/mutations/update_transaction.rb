module Mutations
  class UpdateTransaction < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :description, String, required: true
    argument :from_account_id, ID, required: true
    argument :to_account_id, ID, required: true
    argument :amount, String, required: true

    field :transaction, Types::TransactionType, null: false
    field :errors, [String], null: false

    def resolve(id:, description:, from_account_id:, to_account_id:, amount:)
      transaction = Transaction.find(id)

      if transaction.update(description: description, from_account_id: from_account_id, to_account_id: to_account_id, amount: amount)
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
