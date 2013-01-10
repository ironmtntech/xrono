class AddUserIdToPlutusAccounts < ActiveRecord::Migration
  def change
    add_column :plutus_accounts, :user_id, :integer
  end
end
