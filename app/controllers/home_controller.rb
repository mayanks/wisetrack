class HomeController < ApplicationController
  def index
    @expenses = Category.expense_categories.map{|a| {:label => a.name, :data => a.expense_this_year}}
  end
end
