class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.references :entity, polymorphic: true, null: false

      t.timestamps
    end

    add_index :wallets, [:entity_id, :entity_type], unique: true
  end
end
