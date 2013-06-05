class ReportsController < ApplicationController
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
