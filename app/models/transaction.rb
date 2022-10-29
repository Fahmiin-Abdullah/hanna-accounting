class Transaction < ApplicationRecord
  belongs_to :from_account, class_name: 'Account'
  belongs_to :to_account, class_name: 'Account'

  after_save :recalculate_balance
  after_destroy :recalculate_balance

  def recalculate_balance
    return unless from_account.present? && to_account.present?

    ActiveRecord::Base.transaction do
      from_account.balance = from_account.balance - amount
      to_account.balance = to_account.balance + amount
      from_account.save!
      to_account.save!
    end
  end
end
