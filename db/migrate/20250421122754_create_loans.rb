class CreateLoans < ActiveRecord::Migration[7.2]
  def change
    create_table :loans do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount
      t.decimal :interest_rate
      t.decimal :current_amount
      t.integer :status, default: 0
      t.boolean :approved_by_admin, default: false

      t.timestamps
    end
  end
end
