class Account < ActiveRecord::Base
  attr_accessible :balance, :branch, :name, :number, :ac_type
  validates_presence_of :name, :branch, :number
  scope :saving_accounts, where(["ac_type = 'savings' or ac_type = 'current'"])
  scope :debt_accounts, where(["ac_type = 'credit-card' or ac_type = 'loan'"])
  scope :investment_accounts, where(["ac_type = 'investment'"])
  scope :current_accounts, where(["ac_type = 'current'"])
  scope :expense_accounts, where(["ac_type = 'savings' or ac_type = 'current' or ac_type = 'credit-card'"])

  has_and_belongs_to_many :users
  has_many :transactions, :order => "date, created_at"

  def self.savings_balance(user,on = nil)
    balance = 0
    user.accounts.saving_accounts.each do |account| 
      balance += account.closing_balance(on)
    end
    return balance
  end

  def closing_balance(on = nil)
    on = Date.today unless on
    if self.transactions.count > 0
      t = Transaction.all(:conditions => ["account_id = ? and date <= ?",self.id,on],
                          :limit => 1,
                          :order => "date desc, created_at desc").first
    end

    t.nil? ? self.balance : t.balance
  end

  def update_transactions(from_t = nil)

    if from_t
      t_index = self.transactions.index(from_t)
      return false if t_index.nil?
    else
      t_index = 0
    end

    if t_index == 0
      last_balance = self.balance
    else
      last_balance = self.transactions[t_index-1].balance
    end

    t_index.upto(self.transactions.length-1) do |i|
      t = self.transactions[i]
      if t.t_type == Transaction::TYPE_CREDIT
        t.balance = last_balance + t.amount
      else
        t.balance = last_balance - t.amount
      end
      last_balance = t.balance
      t.save
    end
  end

  def self.pretty(a)
    a = a.to_s
    if a.length <= 3
      return a
    else
      numbers = [a.slice!(-3..-1)]
      while(a.length > 2)
        numbers.insert(0,a.slice!(-2..-1))
      end
      if a.length != 0
        numbers.insert(0,a)
      end
      return numbers.join(",")
    end
  end
end
