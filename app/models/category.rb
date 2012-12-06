class Category < ActiveRecord::Base
  belongs_to :category
  has_many :categories
  has_many :transactions
  attr_accessible :name

  def self.income_categories
    Category.find_by_name('income').categories
  end

  def self.expense_categories
    Category.all(:conditions => ["name != 'income' and name != 'transfer' and category_id is null"], :order => "name")
  end

  def expenses_since(d)
    total = self.transactions.sum(:amount, :conditions => ["date >= ?",d])
    self.categories.each {|s| total += s.expenses_since(d) }
    return total
  end
  def expense_this_month
    expenses_since(Date.today.beginning_of_month)
  end

  def expense_last_3_months
    expenses_since(Date.today.beginning_of_month - 2.months)
  end

  def expense_this_year
    expenses_since(Date.today.beginning_of_year)
  end
end
