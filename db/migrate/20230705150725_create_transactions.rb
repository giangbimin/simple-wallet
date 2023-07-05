class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :source_wallet_id
      t.integer :target_wallet_id
      t.integer :amount, null: false, default: 0

      t.timestamps
    end
  
    add_index :transactions, :source_wallet_id
    add_index :transactions, :target_wallet_id
  end
end
