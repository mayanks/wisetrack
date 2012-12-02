class Transaction < ActiveRecord::Base
  belongs_to :account
  belongs_to :category
  attr_accessible :amount, :description, :date, :t_type, :category_id, :account_id

  before_create :set_balance

  TYPE_CREDIT = 1
  TYPE_DEBIT = 2

  def set_balance
    last_balance = account.closing_balance
    if self.t_type == TYPE_CREDIT
      last_balance += self.amount
    else
      last_balance -= self.amount
    end
    self.balance = last_balance
  end
end
