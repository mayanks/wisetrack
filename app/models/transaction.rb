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

  def self.income_for_month(date)
    start_date = date.beginning_of_month
    end_date = date.end_of_month
    exclude_category = Category.find_by_name('transfer')
    Transaction.sum(:amount, :conditions => ["date >= ? and date <= ? and t_type = 1 and category_id != ? ", start_date, end_date, exclude_category.id])
  end

  def self.expense_for_month(date)
    start_date = date.beginning_of_month
    end_date = date.end_of_month
    exclude_category = Category.find_by_name('transfer')
    Transaction.sum(:amount, :conditions => ["date >= ? and date <= ? and t_type = 2 and category_id != ? ", start_date, end_date, exclude_category.id])
  end
end
