class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :loans
  enum role: { user: 0, admin: 1 }

  after_create :set_default_wallet

  def debit_wallet(amount)
    raise ArgumentError, "Amount must be positive" if amount <= 0
    raise StandardError, "Insufficient funds" if wallet_balance < amount

    update!(wallet_balance: wallet_balance - amount)
  end

  def credit_wallet(amount)
    raise ArgumentError, "Amount must be positive" if amount <= 0

    update!(wallet_balance: wallet_balance + amount)
  end

  private
  def set_default_wallet
    update(wallet_balance: admin? ? 1_000_000 : 10_000)
  end
end
