class LoanAdjustment < ApplicationRecord
  belongs_to :loan

  enum status: { pending: 0, approved: 1, rejected: 2, waiting_for_acceptance: 3 }

  validates :new_amount, :new_interest_rate, presence: true
end
