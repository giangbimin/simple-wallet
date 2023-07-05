class CreateTeamAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :team_accounts do |t|
      t.string :name
      t.bigint :user_id, null: false

      t.timestamps
    end
    add_index :team_accounts, :user_id
  end
end
