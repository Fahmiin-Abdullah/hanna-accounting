# frozen_string_literal: true

module Types
  class TransactionType < Types::BaseObject
    field :id, ID, null: false
    field :description, String
    field :from_account_id, Integer, null: false
    field :to_account_id, Integer, null: false
    field :amount, String
    field :created_at, String
    field :updated_at, String

    def created_at
      object.created_at.strftime('%d/%m/%Y')
    end

    def updated_at
      object.updated_at.strftime('%d/%m/%Y')
    end
  end
end
