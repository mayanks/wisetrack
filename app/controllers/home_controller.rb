class HomeController < ApplicationController
  def index
    if current_user
      @expenses = Category.expense_categories.map{|a| {:label => a.name, :data => a.expense_this_year}}
      d = Date.today.beginning_of_month - 6.months
      @savings = []
      0.upto(5) do |i|
        @savings << ["[Date.parse('#{d}'),#{Account.savings_balance(current_user,d)}]"]
        d += 1.month
      end
    end
  end
end
