class LoanConfirmationService
  def initialize(loan:, user:, status:)
    @loan = loan
    @user = user
    @status = status
  end

  def call
    if @status == "approved"
      approve_loan
    else
      raise "Invalid loan status"
    end
  end

  private

  def approve_loan
    raise "Unauthorized or invalid status" unless @user == @loan.user && (@loan.approved? || @loan.waiting_for_adjustment_acceptance?  || @loan.readjustment_requested)

    admin = User.find_by(role: "admin")
    raise "Admin not found" unless admin
    raise "Insufficient funds" if admin.wallet_balance < @loan.amount

    amount = @loan.loan_adjustments.present? ? @loan.loan_adjustments&.last&.new_amount : loan.amount
    ActiveRecord::Base.transaction do
      admin.wallet_balance -= amount
      @user.wallet_balance += amount

      admin.save!
      @user.save!
      @loan.update!(status: :open)
    end

    "Loan confirmed and opened."
  end
end
