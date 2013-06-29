class ReportsController < ApplicationController
  def index

    saving_accounts = current_user.accounts.saving_accounts
    debt_accounts = current_user.accounts.debt_accounts
    investment_accounts = current_user.accounts.investment_accounts

    d = Date.today.end_of_month - 1.month
    @report = []
    5.downto(0) do |i|
      date = d - i.months

      savings = debt = investment = 0
      saving_accounts.each {|a| savings += a.closing_balance(date)} 
      debt_accounts.each {|a| debt += a.closing_balance(date)} 
      investment_accounts.each {|a| investment += a.closing_balance(date)} 

      expense = Transaction.expense_for_month(date)
      income = Transaction.income_for_month(date)

      @report << { :date => date,
        :expense => expense,
        :income => income,
        :savings => income - expense,
        :balance => {
          :savings => savings,
          :debt => -debt,
          :investment => investment,
          :nav => savings + debt + investment
        }
      }
    end

    @categories = []
    Category.expense_categories.each do |primary_cat|
      primary_cat.categories.each do |cat|
        _h = {:cat => cat, :expense => []}
        @report.each {|r| _h[:expense] << cat.expense_for_month(r[:date])}
        _total = _h[:expense].inject(:+)
        _h[:expense] << _total
        _h[:expense] << _total/@report.length
        @categories << _h
      end
    end
    @categories.sort!{|a,b| b[:expense][-2] <=> a[:expense][-2]}
  end

  def show
    @date = end_date = Date.parse(params[:date])
    start_date = end_date - 1.month
    exclude_category = Category.find_by_name('transfer')

    @income = Transaction.sum(:amount, :conditions => ["date > ? and date <= ? and t_type = 1 and category_id != ? ", start_date, end_date, exclude_category.id])
    @expense = Transaction.sum(:amount, :conditions => ["date > ? and date <= ? and t_type = 2 and category_id != ? ", start_date, end_date, exclude_category.id])

    @income_txns = Transaction.all(:conditions => ["date > ? and date <= ? and t_type = 1 and category_id != ? ", start_date, end_date, exclude_category.id], :order => "amount desc")
    @expense_txns = Transaction.all(:conditions => ["date > ? and date <= ? and t_type = 2 and category_id != ? ", start_date, end_date, exclude_category.id], :order => "amount desc")
  end
end
