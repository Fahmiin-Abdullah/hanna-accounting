module Mutations
  class CreateTransaction < Mutations::BaseMutation
    argument :description, String, required: true
    argument :from_account_id, ID, required: true
    argument :to_account_id, ID, required: true
    argument :amount, String, required: true

    field :transaction, Types::TransactionType, null: false
    field :errors, [String], null: false

    def resolve(description:, from_account_id:, to_account_id:, amount:)
      transaction = Transaction.new(description: description,
                                    from_account_id: from_account_id,
                                    to_account_id: to_account_id,
                                    amount: amount.to_f)

      if transaction.save
        {
          transaction: transaction,
          errors: []
        }
      else
        {
          transaction: nil,
          errors: transaction.errors.messages
        }
      end
    end
  end
end
