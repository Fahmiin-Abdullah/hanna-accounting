class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.decimal :balance, precision: 10, scale: 2, default: '0.00'

      t.timestamps
    end
  end
end
