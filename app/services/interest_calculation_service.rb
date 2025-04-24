class InterestCalculationService
  def initialize(loan)
    @loan = loan
  end

  def call
    return unless @loan.open?

    # Check if a loan adjustment exists
    adjustment = @loan.loan_adjustments.order(created_at: :desc).first

    if adjustment
      # If adjustment exists, use the adjustment's amount and interest rate
      amount = adjustment.new_amount
      interest_rate = adjustment.new_interest_rate
    else
      # If no adjustment, use the original loan values
      amount = @loan.amount
      interest_rate = @loan.interest_rate
    end

    # Calculate interest
    minutes_interval = 5.0
    time_fraction = minutes_interval / (365 * 24 * 60.0) # 5 minutes as a fraction of the year
    interest = amount * (interest_rate / 100.0) * time_fraction

    # Update current_amount on the loan
    @loan.current_amount ||= 0.0
    @loan.current_amount += interest
    @loan.save!
  end
end
