class Transaction < ApplicationRecord
  belongs_to :from_account, class_name: 'Account'
  belongs_to :to_account, class_name: 'Account'

  after_save :recalculate_balance
  after_destroy :recalculate_balance

  def recalculate_balance
    return unless from_account.present? && to_account.present?

    ActiveRecord::Base.transaction do
      from_acc_credit_trx = from_account.credit_transactions.sum(:amount)
      from_acc_debit_trx = from_account.debit_transactions.sum(:amount)
      from_account.balance = from_acc_credit_trx - from_acc_debit_trx
      from_account.save!

      to_acc_credit_trx = to_account.credit_transactions.sum(:amount)
      to_acc_debit_trx = to_account.debit_transactions.sum(:amount)
      to_account.balance = to_acc_credit_trx - to_acc_debit_trx
      to_account.save!
    end
  end
end
