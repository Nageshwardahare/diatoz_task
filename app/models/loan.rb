class Loan < ApplicationRecord
  belongs_to :user
  has_many :loan_adjustments

  enum status: {
    requested: 0,
    approved: 1,
    open: 2,
    closed: 3,
    rejected: 4,
    waiting_for_adjustment_acceptance: 5,
    readjustment_requested: 6
  }

  validates :amount,
            presence: { message: "Loan amount can’t be blank" },
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: 1_00_000,
              message: "Loan amount must be between ₹1 and ₹1,00,000"
            }

  validates :interest_rate,
            presence: { message: "Interest rate can’t be blank" },
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: 100,
              message: "Interest rate must be between 0.01% and 100%"
            }

  scope :recent, -> { order(created_at: :desc) }

  def total_payable
    # Use the most up-to-date amount from interest accrual
    amount_to_use = current_amount.present? ? current_amount + amount : amount

    last_adjustment = loan_adjustments.order(created_at: :desc).first
    rate_to_use = last_adjustment&.new_interest_rate || interest_rate

    return 0 if amount_to_use.nil? || rate_to_use.nil?
    amount_to_use
  end
end
