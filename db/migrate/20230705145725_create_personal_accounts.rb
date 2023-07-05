class CreatePersonalAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :personal_accounts do |t|
      t.string :name
      t.bigint :user_id, null: false

      t.timestamps
    end
    add_index :personal_accounts, :user_id

  end
end
