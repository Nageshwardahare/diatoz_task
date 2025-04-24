# app/controllers/loan_adjustments_controller.rb
class LoanAdjustmentsController < ApplicationController
  def new
    @loan = Loan.find(params[:loan_id])
    @loan_adjustment = @loan.loan_adjustments.new
  end

  def create
    @loan = Loan.find(params[:loan_id])
    @loan_adjustment = @loan.loan_adjustments.new(loan_adjustment_params)

    if @loan_adjustment.save
      @loan.update(status: :waiting_for_adjustment_acceptance)
      redirect_to @loan, notice: "Adjustment proposed successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def loan_adjustment_params
    params.require(:loan_adjustment).permit(:new_amount, :new_interest_rate, :comment)
          .merge(old_amount: @loan.amount, old_interest_rate: @loan.interest_rate, status: :pending)
  end
end
