class InterestCalculationWorker
  include Sidekiq::Worker

  def perform
    Loan.open.find_each do |loan|
      InterestCalculationService.new(loan).call
    end
  end
end
