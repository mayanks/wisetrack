class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :amount
      t.integer :t_type, :default => 0
      t.references :account
      t.references :category
      t.string :description
      t.date :date
      t.integer :balance

      t.timestamps
    end
    add_index :transactions, :account_id
    add_index :transactions, :category_id
    add_index :transactions, :date
  end
end
