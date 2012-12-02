class Account < ActiveRecord::Base
  attr_accessible :balance, :branch, :name, :number, :ac_type
  validates_presence_of :name, :branch, :number

  has_many :transactions, :order => "date desc, created_at desc"

  def closing_balance
    self.transactions.first.nil? ? self.balance : self.transactions.first.balance
  end
end
