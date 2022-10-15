class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.text :description
      t.references :account, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, default: '0.00'

      t.timestamps
    end
  end
end
