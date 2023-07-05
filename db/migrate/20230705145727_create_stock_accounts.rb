class CreateStockAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_accounts do |t|
      t.string :name
      t.bigint :user_id, null: false

      t.timestamps
    end

    add_index :stock_accounts, :user_id
  end
end
