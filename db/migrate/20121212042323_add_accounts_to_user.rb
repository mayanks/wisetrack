class AddAccountsToUser < ActiveRecord::Migration
  def change
    create_table(:accounts_users, :id => false) do |t|
      t.references :account
      t.references :user
    end

    add_index(:accounts_users, [:account_id, :user_id])
  end
end
