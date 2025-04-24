class LoanMailer < ApplicationMailer
  def loan_approved_email(loan)
    @loan = loan
    @user = loan.user

    mail(
      to: @user.email,
      subject: "Your Loan Has Been Approved"
    )
  end
end
