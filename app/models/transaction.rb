class Transaction < ActiveRecord::Base
  belongs_to :account
  belongs_to :category
  attr_accessible :amount, :description, :date, :t_type, :category_id, :account_id

  validates_presence_of :category, :date, :t_type, :amount, :account
  after_create :set_balance

  TYPE_CREDIT = 1
  TYPE_DEBIT = 2

  def set_balance
    self.account.update_transactions(self)
  end
end
