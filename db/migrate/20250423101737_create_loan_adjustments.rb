class CreateLoanAdjustments < ActiveRecord::Migration[7.2]
  def change
    create_table :loan_adjustments do |t|
      t.references :loan, null: false, foreign_key: true
      t.decimal :old_amount
      t.decimal :new_amount
      t.decimal :old_interest_rate
      t.decimal :new_interest_rate
      t.integer :status, default: 0
      t.text :comment

      t.timestamps
    end
  end
end
