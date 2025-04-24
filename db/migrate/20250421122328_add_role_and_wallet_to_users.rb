class AddRoleAndWalletToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :role, :integer, default: 0
    add_column :users, :wallet_balance, :decimal
    add_column :users, :full_name, :string
    add_column :users, :age, :integer
  end
end
