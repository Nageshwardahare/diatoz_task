class LoanApprovedNotificationJob < ApplicationJob
  queue_as :default

  def perform(loan_id)
    loan = Loan.find(loan_id)
    LoanMailer.loan_approved_email(loan).deliver_now
  end
end
