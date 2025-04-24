class LoanConfirmationService
  def initialize(loan:, user:, status:)
    @loan = loan
    @user = user
    @status = status
  end

  def call
    if @status == "approved"
      approve_loan
    elsif @status == "rejected"
      reject_loan
    else
      raise "Invalid loan status"
    end
  end

  private

  def approve_loan
    raise "Unauthorized or invalid state" unless @user == @loan.user && @loan.approved?

    admin = User.find_by(role: "admin")
    raise "Admin not found" unless admin
    raise "Insufficient funds" if admin.wallet_balance < @loan.amount

    ActiveRecord::Base.transaction do
      admin.wallet_balance -= @loan.amount
      @user.wallet_balance += @loan.amount

      admin.save!
      @user.save!
      @loan.update!(status: :open)
    end

    "Loan confirmed and opened."
  end

  def reject_loan
    @loan.update!(status: :rejected)
    "Loan rejected."
  end
end
