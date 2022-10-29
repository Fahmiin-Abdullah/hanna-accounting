class UpdateTransactionsTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :transactions, :account_id, :integer
    add_reference :transactions, :from_account, foreign_key: { to_table: :accounts }
    add_reference :transactions, :to_account, foreign_key: { to_table: :accounts }
  end
end
