class LoansController < ApplicationController
  before_action :set_loan, only: [
    :show, :edit, :update,
    :approve, :reject, :confirm,
    :adjust, :accept_adjustment, :request_readjustment, :repay
  ]

  def index
    @user = current_user
    loans_scope = current_user.admin? ? Loan.recent : current_user.loans.recent
    if params[:status].present?
      loans_scope = loans_scope.where(status: params[:status])
    end
    @loans = loans_scope.page(params[:page]).per(10)
  end

  # Render the form to request a loan
  def new
    @loan = current_user.loans.new
  end

  # Create a new loan request
  def create
    @loan = current_user.loans.new(loan_params)
    @loan.status = :requested

    if @loan.save
      redirect_to loans_path, notice: "Loan request has been submitted."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @loan.requested?
      if @loan.update(loan_params)
        redirect_to @loan, notice: "Loan updated successfully."
      else
        render :edit
      end
    else
      redirect_to @loan, alert: "Loan status cannot be updated because it is not requested."
    end
  end

  # Display the loan details
  def show
    @loan = Loan.includes(:user, :loan_adjustments).find(params[:id])
  end


  # Approve the loan (admin only)
  def approve
    if current_user.admin?
      @loan.update(status: :approved, approved_by_admin: true)
      LoanApprovedNotificationJob.perform_later(@loan.id)

      respond_to do |format|
        format.json { render json: { message: "Loan approved" }, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: { error: "Unauthorized" }, status: :unauthorized }
      end
    end
  end

  def reject
    @loan.update(status: :rejected)
    respond_to do |format|
      format.json { render json: { message: "Loan rejected" }, status: :ok }
      format.html { redirect_to loan_path(@loan), notice: "Loan rejected." }
    end
  end

  def confirm
    if current_user.user?
      LoanConfirmationService.new(loan: @loan, user: current_user, status: params[:status]).call
      redirect_to root_path, notice: "Loan confirmed successfully"
    else
      redirect_to root_path, alert: "Unauthorized action"
    end
  rescue => e
    redirect_to root_path, alert: "Failed to confirm loan: #{e.message}"
  end

  def adjust
    if @loan.update(loan_params.merge(status: :waiting_for_adjustment_acceptance))
      redirect_to loans_path, notice: "Loan adjustment sent for user confirmation."
    else
      redirect_to loans_path, alert: "Adjustment failed."
    end
  end

  def accept_adjustment
    if current_user.user?
      LoanConfirmationService.new(loan: @loan, user: current_user, status: "approved").call
      redirect_to loans_path, notice: "Adjustment accepted."
    else
      redirect_to loans_path, alert: "Unauthorized action"
    end
    rescue => e
      redirect_to loans_path, alert: "Failed to confirm loan: #{e.message}"
  end

  def request_readjustment
    @loan.update(status: :readjustment_requested)
    redirect_to loans_path, notice: "Readjustment request sent to admin."
  end

  def repay
    if @loan.user == current_user && @loan.status == "open"
      total_payable = @loan.total_payable
      user_balance = current_user.wallet_balance

      amount_to_transfer = [ total_payable, user_balance ].min

      ActiveRecord::Base.transaction do
        current_user.update!(wallet_balance: current_user.wallet_balance - amount_to_transfer)

        admin = User.find_by(role: "admin")
        if admin.present?
          admin.update!(wallet_balance: admin.wallet_balance + amount_to_transfer)
        else
          raise ActiveRecord::Rollback, "Admin user not found"
        end
        @loan.update!(status: "closed")
      end

      flash[:notice] = "₹#{amount_to_transfer} transferred and loan closed"
      redirect_to loan_path(@loan)
    else
      flash[:alert] = "Loan is not in a repayable state"
      redirect_to loan_path(@loan)
    end
  end


  private

  def set_loan
    @loan = Loan.find(params[:id])
  end

  def loan_params
    params.require(:loan).permit(:amount, :interest_rate)
  end
end
