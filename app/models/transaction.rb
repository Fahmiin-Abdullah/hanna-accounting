class Transaction < ApplicationRecord
  belongs_to :account

  after_save :recalculate_balance
  after_destroy :recalculate_balance

  def recalculate_balance
    return unless account.present?

    account.balance = account.transactions.sum(:amount)
    account.save!
  end
end
